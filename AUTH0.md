## User metadata

```
{
  "authorization": {
    "groups": [
      "Digital",
      "moj"
    ],
    "roles": [
      "NOMIS integration team"
    ],
    "permissions": [
      "admin"
    ]
  }
}
```

## Omniauth

```
>> request.env['omniauth.auth']
=> {"provider"=>"auth0",
 "uid"=>"auth0|5acf6dcced35db6ff3c24241",
 "info"=>
  {"name"=>"matthew.jacobs+test2@digital.justice.gov.uk",
   "nickname"=>"matthew.jacobs+test2",
   "email"=>nil,
   "image"=>
    "https://s.gravatar.com/avatar/8274b7427a0f5badd2ac9f7a2c7adf01?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fma.png"},
 "credentials"=>
  {"token"=>"3TCpV5uStLqHinqTDOiJPhRWlyQRKjTy",
   "expires_at"=>1523637341,
   "expires"=>true,
   "id_token"=>
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik5EVXlPVVpDT1VJMFJUVXdPVFpHTVRneE5URTJPVU0xUmpVME1qUXlORGcwUWpZMU0wTXpSZyJ9.eyJuaWNrbmFtZSI6Im1hdHRoZXcuamFjb2JzK3Rlc3QyIiwibmFtZSI6Im1hdHRoZXcuamFjb2JzK3Rlc3QyQGRpZ2l0YWwuanVzdGljZS5nb3YudWsiLCJwaWN0dXJlIjoiaHR0cHM6Ly9zLmdyYXZhdGFyLmNvbS9hdmF0YXIvODI3NGI3NDI3YTBmNWJhZGQyYWM5ZjdhMmM3YWRmMDE_cz00ODAmcj1wZyZkPWh0dHBzJTNBJTJGJTJGY2RuLmF1dGgwLmNvbSUyRmF2YXRhcnMlMkZtYS5wbmciLCJ1cGRhdGVkX2F0IjoiMjAxOC0wNC0xMlQxNjozNTozOS4wMTJaIiwiaXNzIjoiaHR0cHM6Ly9tb2otZGV2LmV1LmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw1YWNmNmRjY2VkMzVkYjZmZjNjMjQyNDEiLCJhdWQiOiJHU2dyN3BSNzNJRTRnd1hEV0t0eTBadHlpVVpQZjNrTiIsImlhdCI6MTUyMzU1MDk0MSwiZXhwIjoxNTIzNTg2OTQxfQ.s_h44mz8nn8wCEr-2tfAIH6wJJ5hWacL6zaSuTfmDM6X-5hHXNz4OVHKDzrPEaXeDtzn7U0R5WF47AjCCY6qfyw7sHMsDG8GCRaiYirZxeSikbhpirBfLEdiDOySlM3o5cYPNLB6Q2plUXNyiH64h1PiLUugm9rNlW8dr5V1ne7U14oCwVuzdX_UKvRADkgEMAe-otktW1jO6cNM41FWcPp6c75whC01sBJZW_U3ID0DkvAPEZgY3K7D9OwlDFKg9wjTWkhnPb9JOHVToBEGIjvn9-42vBvJK1MX07zpB-3xXdzvWyA2aQ3uOTHZcNaYFGBezwg9G0x83ZsFtDFmJQ",
   "token_type"=>"Bearer",
   "refresh_token"=>nil},
 "extra"=>
  {"raw_info"=>
    {"sub"=>"auth0|5acf6dcced35db6ff3c24241",
     "nickname"=>"matthew.jacobs+test2",
     "name"=>"matthew.jacobs+test2@digital.justice.gov.uk",
     "picture"=>
      "https://s.gravatar.com/avatar/8274b7427a0f5badd2ac9f7a2c7adf01?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fma.png",
     "updated_at"=>"2018-04-12T16:35:39.012Z"}}}

## JWT

```
>> require 'jwt'
>> jwt = request.env['omniauth.auth'].credentials.id_token
>> JWT.decode(jwt, nil, false)
=> [{"nickname"=>"matthew.jacobs+test2",
  "name"=>"matthew.jacobs+test2@digital.justice.gov.uk",
  "picture"=>
   "https://s.gravatar.com/avatar/8274b7427a0f5badd2ac9f7a2c7adf01?s=480&r=pg&d=https%3A%2F%2Fcdn.auth0.com%2Favatars%2Fma.png",
  "updated_at"=>"2018-04-12T16:35:39.012Z",
  "iss"=>"https://moj-dev.eu.auth0.com/",
  "sub"=>"auth0|5acf6dcced35db6ff3c24241",
  "aud"=>"GSgr7pR73IE4gwXDWKty0ZtyiUZPf3kN",
  "iat"=>1523550941,
  "exp"=>1523586941},
 {"typ"=>"JWT",
  "alg"=>"RS256",
  "kid"=>"NDUyOUZCOUI0RTUwOTZGMTgxNTE2OUM1RjU0MjQyNDg0QjY1M0MzRg"}]
```

