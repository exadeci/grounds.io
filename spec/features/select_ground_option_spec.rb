require 'rails_helper'

feature 'Select a ground option' do
  let(:ground) { GroundPage.new(ground_show_path) }
  let(:custom_session) { CustomSession.new }

  before(:each) do
    ground.visit
  end

  GroundOptions.each do |option, code|
    context "when selecting #{option}: #{code}" do
      before(:each) do
        ground.show_options(option)
        ground.select_option(option, code)
      end

      scenario "saves selected #{option} in session" do
        expect(custom_session).to have_option(option, code)
      end

      scenario "updates #{option} label", js: :true do
        expect(ground).to have_selected_label(option, code)
      end

      scenario "updates code editor #{option}", js: :true do
        expect(ground.editor).to have_option(option, code)
      end

      scenario "closes properly #{option} dropdown", js: :true do
        expect(ground.dropdown(option)).to be_closed
      end

      scenario 'sets focus to code editor' , js: true do
        expect(ground.editor).to be_focused
      end
    end
  end
end
