Feature: Tests for the Home Page

Background: Define URL
    #baseURL
    Given url apiUrl

@smoke
Scenario: Get all tags
    # Given url 'https://conduit.productionready.io/api/tags'     
    Given path 'tags'
    When method Get
    Then status 200
    And match response.tags contains 'cupiditate'
    And match response.tags contains ['cupiditate', 'quia']

    # verify that any of the values exist
    And match response.tags contains any ['welcome', 'dog']

    And match response.tags contains only ["implementations","welcome","introduction","codebaseShow","ipsum","qui","et","quia","cupiditate","deserunt"]
    
    And match response.tags !contains 'chichi-bangbang'
    And match response.tags == "#array"
    # And match response.tags == "#string"
    And match each response.tags == "#string"

@smoke1  
Scenario: Get 10 articles from the page
    * def timeValidator = read('classpath:helpers/timeValidator.js')

    # Given param limit = 10
    # Given param offset = 0
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    # Given url 'https://conduit.productionready.io/api/articles?limit=10&offset=0'
    When method Get 
    Then status 200

    # asserts that the articles array as a length size of 10
    And match response.articles == '#[10]'

    # asserts that articlesCount object has a int value of 163
    And match response.articlesCount == 165
    And match response == {"articles": "#array", "articlesCount": 165}
    And match response.articles[0].createdAt contains '2022'

    # loop through objects 

    # at least one object contains a value
    # And match response.articles[*].favoritesCount contains 18
    And match each response.articles[*].favoritesCount == '#number'
    And match response..bio contains null

    #null or string
    And match each response..bio == '##string'

    # each object must contain a value
    And match each response..following == false
    And match each response..following == '#boolean'
    And match each response.articles == 
    """
        {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": '#array',
            "createdAt": '#? timeValidator(_)',
            "updatedAt": "#? timeValidator(_)",
            "favorited": '#boolean',
            "favoritesCount": '#number',
            "author": {
                "username": "#string",
                "bio": '##string',
                "image": "#string",
                "following": '#boolean'
            }
        }
    """

@condition
Scenario: Conditional logic
    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get 
    Then status 200
    * def favoritesCount = response.articles[0].favoritesCount
    * def article = response.articles[0]

    # simple condition logic w/o returning anything below
    # * if (favoritesCount == 0) karate.call('classpath:helpers/AddLikes.feature', article) 

    # below is used when you want to return a value. if favoritesCount == 0, Then karate call, else return favoritesCount
    * def result = favoritesCount == 0 ? karate.call('classpath:helpers/AddLikes.feature', article).likesCount : favoritesCount

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get 
    Then status 200
    # And match response.articles[0].favoritesCount == 1
    And match response.articles[0].favoritesCount == result


@retry
Scenario: Retry call
    * configure retry = {count: 10, interval: 5000}

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    And retry until response.articles[0].favoritesCount == 2
    When method Get 
    Then status 200

@sleep
Scenario: Sleep call
    * def sleep = function(pause) {java.lang.Thread.sleep(pause)}

    Given params {limit: 10, offset: 0}
    Given path 'articles'
    When method Get 
    * eval sleep(5000)
    Then status 200

@conversion
Scenario: Number to string and string to number
    * def foo = 10
    * def json = {"bar": #(foo+'')}
    * match json == {"bar": '10'}

    * def str = '5'
    # * def json2 = {"bar": #(str*1)}
    # the double tilda will convert a double to an integer removing decimal places
    * def json2 = {"bar": #(~~parseInt(str))}
    * match json2 == {"bar": 5}

@skip  
Scenario: This scenario will be skipped
    * print 'who cares'

@ignore  
Scenario: This scenario will be ignored
    * print 'ignored test'

@regression
Scenario: This scenario is regression
    * print 'regression test'

@functional
Scenario: This scenario will be functional
    * print 'functional test'

@skip @functional
Scenario: This scenario will be functional
    * print 'functional test'