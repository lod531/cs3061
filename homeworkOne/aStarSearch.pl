/*
the arc predicate defines arcs or edges between vertices
CurrentCost is the cost involved in arriving to a particular vertex (sum of all costs of edges that must be traversed in order to arrive at the vertex, from the start vertex) 
CurrentValue is the integer value associated with the current vertex
NextCost is the cost of traversing to the next vertex (from the start vertex)
NextValue is the integer value associated with the next vertex (i.e. the new edge will be between (CurrentValue, NextValue)
*/
arc((CurrentCost-CurrentValue), (NextCost-NextValue), Seed) :- NextValue is CurrentValue*Seed, NextCost is CurrentCost + 1.
arc((CurrentCost-CurrentValue), (NextCost-NextValue), Seed) :- NextValue is CurrentValue*Seed + 1, NextCost is CurrentCost + 2.


/*
search is just a wrapper for the real search. Pairs are used (Where pairs are specified as X-Y, remember, the minus operator is just
a functor in prolog, it doesn't do anything. Using pairs allows me to use keysort, which sorts the vertices by cost (more on that later)
You'll see that Start is converted into a pair 0-Start, where 0 represents that a start node has 0 cost
Seed specifies the seed for the graph generation (see how seed is used in arc)
Target is used in goal predicate
Result is result.
*/
search(Start, Seed, Target, Result) :- frontierSearch([(0-Start)], Seed, Target, Result).

%If the value part of the cost-value part pair satisfies the goal in regards to the target, return value part of current vertex
frontierSearch([(_-Value)|_], _, Target, Value)				:- goal(Value, Target).
%so, this is a large predicate. I'll break it down.
%findall finds all the nodes that are connected with the current vertex. It basically assembles a list of vertices
%the graph here is a binary one, so it's always two of those. Remember that the graph is a directed one.
%add2frontier adds the nodes to the frontier, and is basically an append. It's depth-first, meaning that
%the frontier is treated as a stack. It adds the leftmost node to the front of the list.
%heuristicize adds the heuristic cost to the cost of each vertex
%keysort sorts of cost-value pairs by cost, putting the least cost node in front. 
%deheuristicize removes the heuristic costs, which were only used to sort the array appropriately
%and then, search again.
frontierSearch([Node|Rest], Seed, Target, Result)			:- findall(Next, arc(Node, Next, Seed), Children),
									add2frontier(Children,Rest,New),
									heuristicize(New, Target, Heuristicized),
									keysort(Heuristicized, SortedNew),
									deheuristicize(SortedNew, Target, DeHeuristicized),
									frontierSearch(DeHeuristicized, Seed, Target, Result).

%simply appends first argument to the second argument, and binds it to the third
add2frontier([],Rest,Rest).
add2frontier([H|T],Rest,[H|New]) :- add2frontier(T,Rest,New).

%goal is self explanatory, hopefully
goal(Node, Target) 	:- 0 is Node mod Target.

%adds the heuristic predicted cost to the currentcost of each pair-entry in the list
heuristicize([], _, []).
heuristicize([(CurrentCost-CurrentValue)|T0], Target, [(HeuristicizedCost-CurrentValue)|T1]) 	:- heuristic(CurrentValue, HeuristicValue, Target),
												HeuristicizedCost is round(CurrentCost + HeuristicValue),
												heuristicize(T0, Target, T1).

%inverse of heuristicize
deheuristicize([], _, []).
deheuristicize([(CurrentCost-CurrentValue)|T0], Target, [(HeuristicizedCost-CurrentValue)|T1]) 	:- heuristic(CurrentValue, HeuristicValue, Target),
													HeuristicizedCost is round(CurrentCost - HeuristicValue),
													deheuristicize(T0, Target, T1).
%generated the heuristic value
heuristic(N,Hvalue,Target) 	:- goal(N,Target), !, Hvalue is 0
				;
				Hvalue is 1/N.
