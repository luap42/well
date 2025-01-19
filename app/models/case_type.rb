class CaseType < ApplicationRecord
  default_scope { where(enabled: true) }

  def new_case_no
    today = Date.today
    this_year = today.at_beginning_of_year
    year_code = today.year.to_s[2..]

    cases_with_this_type_in_this_year = Case.where(
      case_type: self,
      created_at: this_year..
    ).where.not(is_canonical: true).count
    case_counter = "%04d" % (cases_with_this_type_in_this_year + 1)

    "#{prefix}/#{case_counter}/#{year_code}"
  end

  def new_canonical_no
    cases_with_this_type_that_are_canonical = Case.where(
      case_type: self,
      is_canonical: true
    ).count
    case_counter = "%03d" % (cases_with_this_type_that_are_canonical + 1)

    "#{prefix}-#{case_counter}"
  end

  protected

  def year_code
  end
end
