require "rails_helper"

RSpec.feature do
  let!(:category) { create(:category_with_items) }
  let(:item1) { category.items.first }

  context "visitor" do
    scenario "deletes only item in cart" do
      visit items_path

      within "##{item1.name.tr(" ", "-")}" do
        click_button("Add to Cart")
      end

      click_on "View Cart"

      click_on "Remove"

      expect(page).to have_content "Successfully removed #{item1.name} from your cart."
      expect(page).to have_link item1.name
      expect(page).to_not have_content item1.description
      expect(page).to_not have_content item1.price_per_unit
      expect(page).to have_content "Total Price: $0.0"
    end

    scenario "deletes multiple items from cart" do
      visit items_path

      within "##{item1.name.tr(" ", "-")}" do
        click_button("Add to Cart")
        click_button("Add to Cart")
      end

      click_on "View Cart"

      click_on "Remove"

      expect(page).to have_content "Total Price: $0.0"
    end

    scenario "deletes an item that clicks to go back to it" do
      visit items_path

      within "##{item1.name.tr(" ", "-")}" do
        click_button("Add to Cart")
      end

      click_on "View Cart"

      click_on "Remove"

      click_on item1.name
      expect(current_path).to eq item_path(item1)
    end
  end
end
