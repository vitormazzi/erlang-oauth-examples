%%
%% This is an example client for the Passaporte Web API.
%%
%% Example usage:
%%
%%   $ make
%%   ...
%%   $ erl -pa ebin -pa path/to/erlang-oauth/ebin -s crypto -s ssl -s inets
%%   ...
%%   1> Consumer = {"...KEY...", "...SECRET...", hmac_sha1}.
%%   ...
%%   2> {ok, Client} = oauth_passaporte_web:start(Consumer).
%%   ...
%%   3> {ok, Token} = oauth_passaporte_web:get_request_token(Client).
%%   ...
%%   4> AuthorizeURL = oauth_passaporte_web:authorize_url(Token).
%%   ...
%%   5> ok = oauth_passaporte_web:get_access_token(Client, "...VERIFIER (PIN)...").
%%   ...
%%   6> {ok, Headers, JSON} = oauth_passaporte_web:get_favorites(Client).
%%   ...
%%
%% Note that before fetching the access token (step 5) you need to have
%% authorized the request token and been given the a verifier PIN at passaporte_web.
%%
-module(oauth_passaporte_web).

-compile(export_all).

start(Consumer) ->
  oauth_client:start(Consumer).

get_request_token(Client, CallbackUrl) ->
  BaseUrl = "http://sandbox.app.passaporteweb.com.br/sso/initiate/?oauth_callback=",
  URL = lists:append(BaseUrl, CallbackUrl),
  oauth_client:get_request_token(Client, URL).

authorize_url(Token) ->
  oauth:uri("http://sandbox.app.passaporteweb.com.br/sso/authorize/", [{"oauth_token", Token}]).

get_access_token(Client, Verifier) ->
  URL = "http://sandbox.app.passaporteweb.com.br/sso/token/",
  oauth_client:get_access_token(Client, URL, [{"oauth_verifier", Verifier}]).

get_favorites(Client) ->
  URL = "http://sandbox.app.passaporteweb.com.br/sso/fetchuserdata/",
  oauth_client:get(Client, URL, []).

verify_credentials(Client) ->
  URL = "http://sandbox.app.passaporteweb.com.br/oauth/resource_owner/",
  oauth_client:get(Client, URL, []).
