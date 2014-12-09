require 'roo'
require 'spreadsheet'

namespace :foods do

  task :ingest => :environment do
    puts "Deleting Food Categories and Foods..."
    Food.delete_all
    FoodCategory.delete_all
    puts "Food Categories and Foods deleted."

    food_db_file = Rails.root.join('lib', 'assets', 'food_database.xlsx').to_s
    puts "Ingesting Foods from: #{food_db_file}"

    xls = Roo::Spreadsheet.open(food_db_file)

    xls.each_with_pagename do |name, sheet|
      category = FoodCategory.new
      category.name = name
      category.save!
      food_count = 0
      sheet.parse(:header_search => ['Food Name']).each do |food_hash|
        next if food_hash["Food Name"] == "Food Name"
        food = Food.new
        food.food_category = category
        food.name = food_hash["Food Name"]           unless food_hash["Food Name"].nil?
        food.serving_size = food_hash["Serving size"]        unless food_hash["Serving size"].nil?
        food.serving_weight = food_hash["Serving weight (g)"]  unless food_hash["Serving weight (g)"].nil?
        food.energy = food_hash["Energy (kJ)"]         unless food_hash["Energy (kJ)"].nil?
        food.protein = food_hash["Protein (g)"]         unless food_hash["Protein (g)"].nil?
        food.total_fat = food_hash["Total Fat (g)"]       unless food_hash["Total Fat (g)"].nil?
        food.saturated_fat = food_hash["Saturated Fat (g)"]   unless food_hash["Saturated Fat (g)"].nil?
        food.cholesterol = food_hash["Cholesterol (mg)"]    unless food_hash["Cholesterol (mg)"].nil?
        food.sugars = food_hash["Sugars (g)"]          unless food_hash["Sugars (g)"].nil?
        food.dietary_fibre = food_hash["Dietary Fibre (g)"]   unless food_hash["Dietary Fibre (g)"].nil?
        food.sodium = food_hash["Sodium (mg)"]         unless food_hash["Sodium (mg)"].nil?
        food.save!
        food_count += 1
      end
      puts "Ingested #{food_count} foods in #{name}."
    end

    puts "Food Ingestion Complete!"
    puts "Total Food Categories: #{FoodCategory.count}"
    puts "Total Foods: #{Food.count}"

  end

end