#  README



This README would normally document whatever steps are necessary to get the

application up and running.



Things you may want to cover:



*  Ruby version

2.4.1



*  System dependencies



*  Configuration



*  Database creation



*  Database initialization



*  How to run the test suite



*  Services (job queues, cache servers, search engines, etc.)



*  Deployment instructions



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

Next:
Strat with the client to consume the API

Deployed on Heroku
url: https://minesweeper-api-mdz.herokuapp.com/minesweepers