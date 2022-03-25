# frozen_string_literal: true

module CustomHelpers
  # This is like `is_expected` except for block matchers such as `raise_error`.
  # Ex:
  #     it { will_be_expected.to raise_error(ArgumentError) }
  def will_be_expected
    expect { subject }
  end
end
