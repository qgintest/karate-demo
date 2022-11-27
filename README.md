# Running tests

Running all tests
`mvn test`

Running individual tests - UI
Override karate runner
extension - karate runner -- override karate runner--- click on scenario to run

Running individual tests - Commandline

When you have a karate.test within the runner
`mvn test -Dtest=NameOfRunner#NameOfTagMethod`

running specific tagged tests
`mvn test "-Dkarate.options=--tags @smoke" -Dtest=ConduitTest`
You don't have to specify the Test Class if there is only one

karate.options - running all tests except certain one's you want to skip
note: maven does not implicitely report it as skipped
`mvn test "-Dkarate.options=--tags ~@skip" -Dtest=ConduitTest`

running multiple categories of tests
`mvn test "-Dkarate.options=--tags ~@functional,@regression"`

below will run tests in those two tags but ignore the one's that have the third tag
`mvn test "-Dkarate.options=--tags ~@functional,@regression --tags~@skip"`

# Enviornment variables
mvn test -Dkarate.env="dev"

# fuzz mtching
assertion of response type, Not the value

# test data generator
  java faker maven

  # Helpful tips
  windows Shift+Alt+F formatting json
  Mac Shift+Option+F

  # Debugging tips
  - misspel a keyword e.g., path is pth
     No step definition method found
 
  - = instread of ==
   syntax error, expected '==' for match

  - misspell a file name
     could not find or read file

# Parallel runs
if you want one or more tests NOT to be ran in parallel, use `@parallel=false` 

# connecting to database
- need it if you want to assert post request made updates to DB and there is no endpoint available to check
- 






