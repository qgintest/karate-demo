function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://conduit.productionready.io/api/'
  }

  if (env == 'dev') {
    config.userEmail = 'abe@gmail.com'
    config.userPass = 'abe123456'
  } else if (env == 'qa') {
    config.userEmail = 'notSetupYet'
    config.userPass = 'notYet'
  }

   //Below is used to call feature files before any test only once. 
 var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken

 //a global way to configure all headers for all tests
 karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config; //config object is visible to all future files
}