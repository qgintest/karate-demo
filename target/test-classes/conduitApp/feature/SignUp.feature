Feature: Sign up new user

Background: Preconditions
    * def dataGenerator = Java.type('helpers.DataGenerator')
    Given  url apiUrl

@signup
Scenario: New user signup

    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUserName = dataGenerator.getRandomUserName()

    # if you need to create instance of an object, JS is needed to call nonstatic java method
    # notice how js function is anynmous, has no params
    * def jsFunction = 
    """
        function (){
            var DataGenerator = Java.type('helpers.DataGenerator')
            var generator = new DataGenerator()
            return generator.getRandomUserNamAsObject()
        }

    """

    * def randomUserName2 = call jsFunction

     # Given def userData = {"email": randomEmail, "username": randomUserName}
    #  Given def userData = {"email": "some3Email@gmail.com", "username": "SuperCobraKai2"}

    Given path 'users'
    # And request {"user": {"email": #('Test-'+userData.email), "password": "somePassword123", "username": #(userData.username)}}
    
    # "email": #('Test-'+userData.email), 
    And request 
    """
        {
            "user": {
              
                "email": #(randomEmail), 
                "password": "somePassword123", 
                "username": #(randomUserName2)
            }        
        }
    """
    When method Post
    Then status 200

    @datadriven    
    Scenario Outline: Data Driven Scenario Test 
    * def randomEmail = dataGenerator.getRandomEmail()
    * def randomUserName = dataGenerator.getRandomUserName()

    Given path 'users'
    And request 
    """
        {
            "user": {
                "email": "<email>", 
                "password": "<password>", 
                "username": "<username>"
            }        
        }
    """
    When method Post
    Then status 422
    And match response == <errorResponse>

    Examples:
       | email                   | password    | username        | errorResponse                                      |
       | #(randomEmail)          | Karate123 | KarateUser123     | {"errors":{"username":["has already been taken"]}} |
       | 'KarateUser1@test.com'  | Karate123 | #(randomUserName) | {"errors":{"email":["has already been taken"]}}    |            