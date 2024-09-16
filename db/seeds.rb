# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Seed Users and Teams
# Seed Users and Teams
user1 = User.create(name: 'anas', email: 'john@example.com', password: 'password')
team1 = Team.create(name: 'Team Alpha', email: 'alpha@example.com', password: 'password')

# Seed Stocks
stock1 = Stock.create(name: 'Apple Inc.', symbol: 'AAPL')
stock2 = Stock.create(name: 'Tesla Inc.', symbol: 'TSLA')

# Add Funds to Wallets
user1.wallet.deposit(1000)
team1.wallet.deposit(5000)
stock1.wallet.deposit(10000)
stock2.wallet.deposit(20000)
