#  Minesweepers Games API
This README would normally document whatever steps are necessary to get the application up and running.
Things you may want to cover:
*  Ruby version
2.4.1
*  System dependencies
Rails 5.2.4

*  Configuration to run it local
  Clone the Git Repository
  `git clone git@github.com:pablorodriguez/minesweeper-api.git`
*  Database creation
  `bundle exec rake db:create`
  `bundle exec rake db:migrate`

*  How to run the test suite
  `bundle exec rspec`

*  Deployment instructions
Add Heroku Repository
`git add heroku https://git.heroku.com/minesweeper-api-mdz.git`
`git push heroku`

**Development notes**
 1. First I focus on the logic of the game
 2. Add logic to get the adjacents cells from one cell
 3. Add test to validate adjacents on borders
 4. Check if all the adjacents cells do not have a mine
 5. Clear all adjacents cell and repeat with a recursive method call
 6. Add print logic
 7. Add more test to validate the cell contents

 Next:
 Start with the API

  8. Refactor to move the game service into a Model
  9. Add model validations and specs
  10. Add Controller and specs
  11. Do multiple refactos and add more test
  12. More validation to the model

Next:
Strat with the client to consume the API

Deployed on Heroku
url: https://minesweeper-api-mdz.herokuapp.com
There you can get the list of game created with some basic information,
IMPORTANT !!! IT SHOW WHERETHE MINES ARE
