-module(mfk_resource).

-export([
            allowed_methods/2,
            content_types_accepted/2,
            content_types_provided/2,
            from_json/2,
            init/1,
            options/2,
            process_post/2,
            to_json/2
        ]).

-include_lib("webmachine/include/webmachine.hrl").

-spec init(list()) -> {ok, term()}.
init(State) ->
    {ok, State}.

allowed_methods(Req, State) ->
    {['GET','PUT', 'OPTIONS', 'POST'], Req, State}.

content_types_provided(Req, State) ->
    {[{"application/json", to_json}], Req, State}.

content_types_accepted(Req, State) ->
   {[{"application/json", from_json}], Req, State}.

options(Req, State) ->
    {[
       {<<"access-control-allow-origin">>, <<"*">>},
       {<<"access-control-allow-methods">>, <<"OPTIONS, PUT, GET, POST">>},
       {<<"Access-Control-Allow-Headers">>, <<"Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With">>}
     ], Req, State}.

 process_post(Req, State) ->
     Json = wrq:req_body(Req),
     Ejson = jiffy:decode(Json),
     PersonEjson = person:insert(Ejson),
     PersonJson = jiffy:encode(PersonEjson),
     UpdatedReqData = wrq:set_resp_header("Access-Control-Allow-Origin", "http://localhost:4200", Req),
     FinalReq = wrq:set_resp_body(PersonJson, UpdatedReqData),
     {true, FinalReq, State}.

-spec to_json(wrq:reqdata(), term()) -> {iodata(), wrq:reqdata(), term()}.
to_json(Req, State) ->
    People = person:fetch_three(),
    PeopleJson = jiffy:encode(People),
    UpdatedReqData = wrq:set_resp_header("Access-Control-Allow-Origin", "http://localhost:4200", Req),
    {PeopleJson, UpdatedReqData, State}.

from_json(Req, State) ->
    Json = wrq:req_body(Req),
    Ejson = jiffy:decode(Json),
    StatsEjson = person:vote(Ejson),
    StatsJson = jiffy:encode(StatsEjson),
    Req1 = wrq:set_resp_header("Access-Control-Allow-Origin", "http://localhost:4200", Req),
    FinalReq = wrq:set_resp_body(StatsJson, Req1),
    {true, FinalReq, State}.
