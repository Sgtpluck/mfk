-module(person).

-compile({parse_transform, sqerl_gobot}).

-export([
         '#insert_fields'/0,
         '#update_fields'/0,
         '#statements'/0,
         '#table_name'/0
        ]).

-export([
         fetch_three/0,
         vote/1
        ]).

-record(?MODULE, {id,
        name,
        marry,
        fuck,
        kill
    }).

'#insert_fields'() ->
    [name].

'#update_fields'() ->
    [marry,fuck,kill].

'#statements'() ->
    [default,
       {fetch_all, sqerl_rec:gen_fetch_all(?MODULE, name)},
       {fetch_three, "SELECT * FROM people ORDER BY RANDOM() LIMIT 3"}
    ].

'#table_name'() ->
    "people".

fetch_three() ->
    People = sqerl_rec:qfetch(person, fetch_three, []),
    Ejson = [build_ejson(Person) || Person <- People],
    {[{<<"candidates">>, Ejson}]}.

build_ejson(#person{id=Id, name=Name}) ->
    {[
        {<<"id">>, Id},
        {<<"name">>, Name},
        {<<"marry">>, false},
        {<<"fuck">>, false},
        {<<"kill">>, false}
    ]}.

vote(_Ejson) ->
    {error, not_implemented}.
