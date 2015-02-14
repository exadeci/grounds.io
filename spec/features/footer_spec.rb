require 'rails_helper'

feature 'Footer' do
  before(:each) do
    visit(root_path)
  end

  FooterLinks.each do |description, name, href|
    scenario "has a link to #{description}" do
      expect(footer).to have_link(name, href: href)
    end
  end

  def footer
    find('footer')
  end
end
