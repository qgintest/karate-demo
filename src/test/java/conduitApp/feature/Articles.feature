Feature: Articles


Background: Define URL
     Given url apiUrl
     * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
     * def dataGenerator = Java.type('helpers.DataGenerator')
     * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
     * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
     * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

    # object tokenResponse will hold ALL variables defined in below feature

    # callonce is used because Background runs the scoped code for each scenario. callonce uses cached value
    #* def tokenResponse = callonce read('classpath:helpers/CreateToken.feature') {"email": "abe@gmail.com", "password": "abe123456"}
    # * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature')

    # * def token = tokenResponse.authToken

    @createArticle
Scenario: Create new article
        # Given header Authorization = 'Token ' + token
        Given path 'articles'
        # And request {"article": {"tagList": [], "title": "Some Title2", "description": "some desc", "body": "body"}}
        And request articleRequestBody
        When method Post
        Then status 200
        # And match response.article.description == 'some desc'
        And match response.article.description == articleRequestBody.article.description

    @runNow
    Scenario: Create and Delete article
        # Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article": {"tagList": [], "title": "Delete Article", "description": "some desc", "body": "body"}}
        When method Post
        Then status 200
        And match response.article.description == 'some desc'
        * def articleId = response.article.slug

        # Given header Authorization = 'Token ' + token
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get 
        Then status 200
        And match response.articles[0].title == 'Delete Article'

        # Given header Authorization = 'Token ' + token
        Given path 'articles',articleId
        When method Delete
        Then status 204

        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get 
        Then status 200
        And match response.articles[0].title != 'Delete Article'
