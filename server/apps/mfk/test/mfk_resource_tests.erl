-module(mfk_resource_tests).

-include_lib("hoax/include/hoax.hrl").

-compile([export_all]).

fixture_test_() ->
    hoax:fixture(?MODULE).

to_json_fetches_three_people_and_returns_them() ->
    hoax:expect(receive
        person:fetch_three() -> people;
        jiffy:encode(people) -> peopleJson;
        wrq:set_resp_header("Access-Control-Allow-Origin", "http://localhost:4200", req) -> req1
                end),
    Result = mfk_resource:to_json(req, undefined),
    ?assertEqual({peopleJson, req1, undefined}, Result),
    ?verifyAll.

from_json_calls_the_person_vote_function_and_returns_stat_json() ->
    hoax:expect(receive
        wrq:req_body(req) -> json;
        jiffy:decode(json) -> ejson;
        person:vote(ejson) -> stats_ejson;
        jiffy:encode(stats_ejson) -> stats_json;
        wrq:set_resp_header("Access-Control-Allow-Origin", "http://localhost:4200", req) -> req1;
        wrq:set_resp_body(stats_json, req1) -> req2
                end),

    Result = mfk_resource:from_json(req, undefined),
    ?assertEqual({true, req2, undefined}, Result),
    ?verifyAll.
