require "odf-report"
require "html2odt"
require "libreconv"

module WritingHelper
  def create_writing(wdraft)
    first_stage = nil

    tpl = wdraft.writing_type.template
    tpl_path = ActiveStorage::Blob.service.path_for(tpl.key)

    report = ODFReport::Report.new(tpl_path) do |r|
      r.add_field :case_no, wdraft.case.case_no
      r.add_field :'case.title', wdraft.case.title

      r.add_field :'manager.name', wdraft.case.manager.display_name
      r.add_field :'manager.email', wdraft.case.manager.email
      r.add_field :'manager.shortcode', wdraft.case.manager.shortcode

      r.add_field :'author.name', wdraft.user.display_name
      r.add_field :'author.email', wdraft.user.email
      r.add_field :'author.shortcode', wdraft.user.shortcode

      r.add_field :'writing.subject', wdraft.title
      r.add_field :'writing.content', "{{content}}"
      r.add_field :'writing.date', wdraft.writing_date.strftime("%d.%m.%Y")

      if wdraft.writing_type.has_recipient
        r.add_field :'recipient.name', wdraft.participant.name
        r.add_field :'recipient.address', wdraft.participant.address_field
        r.add_field :'recipient.contact_details', wdraft.participant.contact_details
        r.add_field :'recipient.email', wdraft.participant.email
        r.add_field :'recipient.tel_no', wdraft.participant.tel_no
        r.add_field :'recipient.mobile_no', wdraft.participant.mobile_no
        r.add_field :'recipient.fax_no', wdraft.participant.fax_no
      end
    end

    first_stage = Tempfile.new("wdraft-a-#{wdraft.id}", binmode: true)
    report.generate(first_stage.path)

    doc = Html2Odt::Document.new(template: first_stage.path, html: prepare_content(wdraft.content))
    doc.data
  ensure
    first_stage&.close
  end

  def convert_to_pdf(wdraft, data)
    second_stage = Tempfile.new("wdraft-b-#{wdraft.id}", binmode: true)
    third_stage = Tempfile.new("wdraft-c-#{wdraft.id}", binmode: true)

    second_stage << data
    Libreconv.convert(second_stage.path, third_stage.path)
    third_stage.rewind
    IO.read third_stage
  ensure
    second_stage&.close
    third_stage&.close
  end

  def prepare_content(content)
    content = content.to_s
    content = content.gsub("<br><br>", "</div><div>")
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
