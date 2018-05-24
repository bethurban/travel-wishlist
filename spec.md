# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
  Sinatra was used.
- [x] Use ActiveRecord for storing information in a database
  ActiveRecord stores all info in tables.
- [x] Include more than one model class (list of model class names e.g. User, Post, Category)
  Three model classes: User, VisitedPlace, and WishedPlace
- [x] Include at least one has_many relationship on your User model (x has_many y, e.g. User has_many Posts)
  The User class has_many VisitedPlaces and has_many WishedPlaces
- [x] Include at least one belongs_to relationship on another model (x belongs_to y, e.g. Post belongs_to User)
  The VisitedPlace class belongs_to User, as does WishedPlace.
- [x] Include user accounts
  Users must sign up and can only access app pages when logged in.
- [x] Ensure that users can't modify content created by other users
  Users can only edit and delete VisitedPlaces and WishedPlaces that they created themselves.
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying
  VisitedPlace and WishedPlace both have CRUD routes.
- [x] Include user input validations
  Users must include a destination name for WishedPlace and must include a destination name and travel date for VisitedPlace.
- [x] Display validation failures to user with error message (example form URL e.g. /posts/new)
  Added flash messages to inform users when forms are properly filled out, a post is deleted, or the user needs to log in.
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
