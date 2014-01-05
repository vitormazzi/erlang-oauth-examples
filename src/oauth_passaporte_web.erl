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
%%   3> CallbackUrl = "http://sandbox.app.passaporteweb.com.br/sso/oob/".
%%   ...
%%   4> {ok, Token} = oauth_passaporte_web:get_request_token(Client, CallbackUrl, sandbox).
%%   ...
%%   5> AuthorizeURL = oauth_passaporte_web:authorize_url(Token, sandbox).
%%   ...
%%   6> ok = oauth_passaporte_web:get_access_token(Client, "...VERIFIER (PIN)...", sandbox).
%%   ...
%%   7> {ok, Headers, JSON} = oauth_passaporte_web:fetch_user_data(Client, sandbox).
%%   ...
%%
%% Note that before fetching the access token (step 5) you need to have
%% authorized the request token and been given the a verifier PIN at passaporte_web.
%%
-module(oauth_passaporte_web).

-export([start/1, get_request_token/3, authorize_url/2,
    get_access_token/3, fetch_user_data/2, verify_credentials/2 ]).

start(Consumer) ->
  oauth_client:start(Consumer).

get_request_token(Client, CallbackUrl, Environment) ->
  URL = get_env_url("/sso/initiate/", Environment),
  Params = [{"oauth_callback", CallbackUrl}],
  oauth_client:get_request_token(Client, URL, Params).

authorize_url(Token, Environment) ->
  URL = get_env_url("/sso/authorize/", Environment),
  oauth:uri(URL, [{"oauth_token", Token}]).

get_access_token(Client, Verifier, Environment) ->
  URL = get_env_url("/sso/token/", Environment),
  oauth_client:get_access_token(Client, URL, [{"oauth_verifier", Verifier}]).

fetch_user_data(Client, Environment) ->
  URL = get_env_url("/sso/fetchuserdata/", Environment),
  oauth_client:get(Client, URL, []).

verify_credentials(Client, Environment) ->
  URL = get_env_url("/oauth/resource_owner/", Environment),
  oauth_client:get(Client, URL, []).

%%
%% Helper functions
%%
get_env_url(Path, Environment) ->
  Host = case Environment of
    production -> "https://app.passaporteweb.com.br";
    sandbox -> "http://sandbox.app.passaporteweb.com.br";
    _ -> error
  end,
  Host ++ Path.
