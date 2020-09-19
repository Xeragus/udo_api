# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Tag.create!([{ name: 'FAMILY', code: 'family' },
             { name: 'WORK', code: 'work' },
             { name: 'HEALTH', code: 'health' },
             { name: 'LEARNING', code: 'learning' },
             { name: 'READING', code: 'reading' },
             { name: 'MOVIES', code: 'movies' },
             { name: 'FUN', code: 'fun' },
             { name: 'MUSIC', code: 'music' },
             { name: 'FOOD', code: 'food' },
             { name: 'SPORT', code: 'sport' },
             { name: 'SHOPPING', code: 'shopping' }])
