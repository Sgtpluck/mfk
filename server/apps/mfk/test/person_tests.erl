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
                            {<<"kill">>, false}
                        ]},
                        {[
                            {<<"id">>,<<"2">>},
                            {<<"name">>,<<"Dean Venture">>},
                            {<<"marry">>, false},
                            {<<"fuck">>, false},
                            {<<"kill">>, false}
                        ]},
                        {[
                            {<<"id">>,<<"3">>},
                            {<<"name">>,<<"Doc Venture">>},
                            {<<"marry">>, false},
                            {<<"fuck">>, false},
                            {<<"kill">>, false}
                        ]}]
                    }]},

    Result = person:fetch_three(),

    ?assertEqual(ExpectedEjson, Result),
    ?verifyAll.

% vote_updates_database_and_returns_list_of_people_with_stats() ->
%
%     Result = person:vote(VoteEjson),
%     ?assertEqual(ExpectedEjson, Result),
%     ?verifyAll.


% [
%   {
%     "id": "c3240b81-347f-43ba-bf04-ca51cc008c49",
%     "name": "Abraham Lincoln",
%     "marry": true,
%     "fuck": false,
%     "kill": false,
%     "selected": true
%   },
%   {
%     "id": "10b36019-1382-46af-a07d-392cd57ee91d",
%     "name": "John F. Kennedy",
%     "marry": false,
%     "fuck": true,
%     "kill": false,
%     "selected": true
%   },
%   {
%     "id": "d3fddf54-a2da-4621-8176-d84401e26067",
%     "name": "Barack Obama",
%     "marry": false,
%     "fuck": false,
%     "kill": true,
%     "selected": true
%   }
% ]
