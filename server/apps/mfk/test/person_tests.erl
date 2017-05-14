-module(person_tests).

-include_lib("hoax/include/hoax.hrl").

-compile([export_all]).

fixture_test_() ->
    hoax:fixture(?MODULE).

fetch_three_calls_sqerl_rec_fetch_three_then_processes_records() ->
    Person1 = person:fromlist([{id, <<"1">>},{name, <<"Hank Venture">>},{marry, 0}, {fuck, 0}, {kill, 0}]),
    Person2 = person:fromlist([{id, <<"2">>},{name, <<"Dean Venture">>},{marry, 0}, {fuck, 0}, {kill, 0}]),
    Person3 = person:fromlist([{id, <<"3">>},{name, <<"Doc Venture">>},{marry, 0}, {fuck, 0}, {kill, 0}]),

    hoax:expect(receive
        sqerl_rec:qfetch(person, fetch_three, []) -> [Person1, Person2, Person3]
    end),

    ExpectedEjson =
                    {[{<<"candidates">>,
                        [{[
                            {<<"id">>,<<"1">>},
                            {<<"name">>,<<"Hank Venture">>},
                            {<<"marry">>, false},
                            {<<"fuck">>, false},
                            {<<"kill">>, false},
                            {<<"selected">>, <<"unselected">>}
                        ]},
                        {[
                            {<<"id">>,<<"2">>},
                            {<<"name">>,<<"Dean Venture">>},
                            {<<"marry">>, false},
                            {<<"fuck">>, false},
                            {<<"kill">>, false},
                            {<<"selected">>, <<"unselected">>}
                        ]},
                        {[
                            {<<"id">>,<<"3">>},
                            {<<"name">>,<<"Doc Venture">>},
                            {<<"marry">>, false},
                            {<<"fuck">>, false},
                            {<<"kill">>, false},
                            {<<"selected">>, <<"unselected">>}
                        ]}]
                    }]},

    Result = person:fetch_three(),

    ?assertEqual(ExpectedEjson, Result),
    ?verifyAll.

vote_updates_database_and_returns_list_of_people_with_stats() ->
    Person1 = person:fromlist([{id, <<"1">>},{name, <<"Hank Venture">>},{marry, 10}, {fuck, 17}, {kill, 0}]),
    Person2 = person:fromlist([{id, <<"2">>},{name, <<"Dean Venture">>},{marry, 3}, {fuck, 5}, {kill, 7}]),
    Person3 = person:fromlist([{id, <<"3">>},{name, <<"Doc Venture">>},{marry, 0}, {fuck, 0}, {kill, 13}]),

    Person4 = person:setvals([{fuck, 18}], Person1),
    Person5 = person:setvals([{marry, 4}], Person2),
    Person6 = person:setvals([{kill, 14}], Person3),

    VoteEjson = [{[
            {<<"name">>,<<"Hank Venture">>},
            {<<"vote">>, <<"fuck">>}
          ]},
          {[
            {<<"name">>,<<"Dean Venture">>},
            {<<"vote">>, <<"marry">>}
          ]},
          {[
            {<<"name">>,<<"Doc Venture">>},
            {<<"vote">>, <<"kill">>}]}],

        hoax:expect(receive
            sqerl_rec:qfetch(person, fuck, [<<"Hank Venture">>]) -> Person4;
            sqerl_rec:qfetch(person, marry, [<<"Dean Venture">>]) -> Person5;
            sqerl_rec:qfetch(person, kill, [<<"Doc Venture">>]) -> Person6
        end),

    ExpectedEjson =
                    {[{<<"stats">>,
                        [{[
                            {<<"id">>,<<"1">>},
                            {<<"name">>,<<"Hank Venture">>},
                            {<<"marry">>, 10},
                            {<<"fuck">>, 18},
                            {<<"kill">>, 0}
                        ]},
                        {[
                            {<<"id">>,<<"2">>},
                            {<<"name">>,<<"Dean Venture">>},
                            {<<"marry">>, 4},
                            {<<"fuck">>, 5},
                            {<<"kill">>, 7}
                        ]},
                        {[
                            {<<"id">>,<<"3">>},
                            {<<"name">>,<<"Doc Venture">>},
                            {<<"marry">>, 0},
                            {<<"fuck">>, 0},
                            {<<"kill">>, 14}
                        ]}]
                    }]},

    Result = person:vote(VoteEjson),
    ?assertEqual(ExpectedEjson, Result),
    ?verifyAll.
