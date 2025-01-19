require "odf-report"
require "html2odt"

module WritingHelper
  def create_writing(wdraft)
    first_stage = nil

    tpl = wdraft.writing_type.template
    tpl_path = ActiveStorage::Blob.service.path_for(tpl.key)

    report = ODFReport::Report.new(tpl_path) do |r|
      r.add_field :case_no, wdraft.case.case_no

      r.add_field :'author.name', wdraft.user.display_name
      r.add_field :'author.email', wdraft.user.email
      r.add_field :'author.shortcode', wdraft.user.shortcode

      r.add_field :'writing.subject', wdraft.title
      r.add_field :'writing.content', "{{content}}"
    end

    first_stage = Tempfile.new("wdraft-a-#{wdraft.id}", binmode: true)
    report.generate(first_stage.path)

    doc = Html2Odt::Document.new(template: first_stage.path, html: prepare_content(wdraft.content))
    doc.data
  ensure
    first_stage&.close
  end

  def prepare_content(content)
    content = content.to_s
    prepd = Nokogiri.HTML(content).tap do |superdoc|
      doc = superdoc.css("div.trix-content").first
      doc.xpath("//comment()").remove
      doc.css("div").each do |div|
        div.name = "p"
        div.css("br").each { |n| n.remove }
        div.inner_html.strip
      end
    end

    prepd.css("div.trix-content").inner_html
  end
end


# Hotfixing some weird UTF8 stuff
class Html2Odt::Document
  CONTENT_REGEX = /<text:p[^>]*>{{content}}<\/text:p>/u

  def read_xmls
    unless File.readable?(@template)
      raise ArgumentError, "Cannot read template file #{@template.inspect}"
    end

    Zip::File.open(@template) do |zip_file|
      @tpl_content_xml  = zip_file.read("content.xml").force_encoding("UTF-8")
      @tpl_manifest_xml = zip_file.read("META-INF/manifest.xml")
      @tpl_meta_xml     = zip_file.read("meta.xml")
      @tpl_styles_xml   = zip_file.read("styles.xml")
    end

    unless @tpl_content_xml =~ CONTENT_REGEX
      raise ArgumentError, "Template file does not contain `{{content}}` paragraph"
    end

  rescue Zip::Error
    raise ArgumentError, "Template file does not look like an ODT file - #{$!.message}"
  rescue Errno::ENOENT
    raise ArgumentError, "Template file does not contain expected file - #{$!.message}"
  end
end
