-module(mfk_resource_tests).

-include_lib("hoax/include/hoax.hrl").

-compile([export_all]).

fixture_test_() ->
    hoax:fixture(?MODULE).


init_returns_ok_state() ->
    ?assertEqual({ok, state}, mfk_resource:init(state)).

allowed_methods_returns_methods_allowed() ->
    Expected = {['GET','PUT', 'OPTIONS', 'POST'], req, state},
    Result = mfk_resource:allowed_methods(req, state),
    ?assertEqual(Expected, Result).

to_json_fetches_three_people_and_returns_them() ->
    hoax:expect(receive
        person:fetch_three() -> people;
        jiffy:encode(people) -> peopleJson;
        wrq:set_resp_header("Access-Control-Allow-Origin", "http://localhost:4200", req) -> req1
                end),
    Result = mfk_resource:to_json(req, state),
    ?assertEqual({peopleJson, req1, state}, Result),
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

    Result = mfk_resource:from_json(req, state),
    ?assertEqual({true, req2, state}, Result),
    ?verifyAll.

process_post_calls_create_on_person_and_returns_true() ->

    hoax:expect(receive
        wrq:req_body(req) -> json;
        jiffy:decode(json) -> ejson;
        person:insert(ejson) -> person_ejson;
        jiffy:encode(person_ejson) -> person_json;
        wrq:set_resp_header("Access-Control-Allow-Origin", "http://localhost:4200", req) -> req1;
        wrq:set_resp_body(person_json, req1) -> req2
                end),
    Result = mfk_resource:process_post(req, state),
    ?assertEqual({true, req2, state}, Result),
    ?verifyAll.
