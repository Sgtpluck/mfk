-module(person).

-compile({parse_transform, sqerl_gobot}).

-export([
         '#insert_fields'/0,
         '#update_fields'/0,
         '#statements'/0,
         '#table_name'/0
        ]).

-export([
         do_vote/1,
         fetch_three/0,
         insert/1,
         vote/1
        ]).

-record(?MODULE, {
        name,
        marry = 0,
        fuck = 0,
        kill = 0
    }).

'#insert_fields'() ->
    [name].

'#update_fields'() ->
    [marry,fuck,kill].

'#statements'() ->
    [default,
       {fetch_all, sqerl_rec:gen_fetch_all(?MODULE, name)},
       {fetch_three, "SELECT * FROM people ORDER BY RANDOM() LIMIT 3"},
       {marry, "UPDATE people SET  marry = (marry + 1) WHERE name = $1 RETURNING *"},
       {fuck, "UPDATE people SET  fuck = (fuck + 1) WHERE name = $1 RETURNING *"},
       {kill, "UPDATE people SET  kill = (kill + 1) WHERE name = $1 RETURNING *"}
    ].


'#table_name'() ->
    "people".

fetch_three() ->
    People = sqerl_rec:qfetch(person, fetch_three, []),
    Ejson = [build_ejson(Person) || Person <- People],
    {[{<<"candidates">>, Ejson}]}.

build_ejson(#person{name=Name}) ->
    {[
        {<<"name">>, Name},
        {<<"marry">>, false},
        {<<"fuck">>, false},
        {<<"kill">>, false},
        {<<"selected">>, <<"unselected">>}
    ]}.

do_vote(Person) ->
    Name = ej:get([<<"name">>], Person),
    Action = erlang:binary_to_atom(ej:get([<<"vote">>], Person), utf8),
    [UpdatedPerson] = sqerl_rec:qfetch(person, Action, [Name]),
    build_stat_ejson(UpdatedPerson).

insert(PersonEjson) ->
    Name = ej:get([<<"name">>], PersonEjson),
    Person = #person{name=Name},
    sqerl_rec:insert(Person),
    PersonEjson.

vote(PersonEjson) ->
    Stats = [ do_vote(Person) || Person <- PersonEjson],
    {[{<<"stats">>, Stats}]}.

build_stat_ejson(#person{
                         name=Name,
                         marry=Marry,
                         fuck=Fuck,
                         kill=Kill}) ->
        {[
            {<<"name">>, Name},
            {<<"marry">>, Marry},
            {<<"fuck">>, Fuck},
            {<<"kill">>, Kill}
        ]}.
