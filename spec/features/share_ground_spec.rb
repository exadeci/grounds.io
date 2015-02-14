require 'rails_helper'

feature 'Share a ground' do
  let(:ground) { GroundPage.new(ground_show_path) }

  before(:each) do
    ground.visit
    ground.share
  end

  scenario 'adds to page a shared url to this ground', js: :true do
    expect(ground.shared_url).not_to be_empty
  end

  scenario 'adds to page a visible link to this shared ground', js: :true do
    expect(ground.shared_url).to be_visible
  end

  scenario 'sets focus to this shared ground url', js: :true do
    expect(ground.shared_url).to have_focus
  end

  context 'when selecting another language' do
    before(:each) do
      ground.show_options('language')
      ground.select_option('language', 'golang')
    end

    it_behaves_like 'a ground without shared url'
  end

  context 'when typing inside the code editor' do
    before(:each) do
      ground.editor_type_inside
    end

    it_behaves_like 'a ground without shared url'
  end
end
