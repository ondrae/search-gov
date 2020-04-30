# frozen_string_literal: true

describe ResultsHelper do
  describe '#link_to_result_title' do
    it 'makes a link with all the stuffs' do
      output = link_to_result_title('1', 'test title', 'https://test.gov', '2', 'BOOS')
      expected_output = '<a data-click="{&quot;i&quot;:&quot;1&quot;'\
                        ',&quot;p&quot;:&quot;2&quot;,&quot;s&quot;:&quot;BOOS&quot;}"'\
                        ' href="https://test.gov">test title</a>'
      expect(output).to eq expected_output
    end
  end
end
