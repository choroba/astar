use strict;
use warnings;
use Test::More;

{
    package AI::Pathfinding::AStar::TestMap;
    use parent 'AI::Pathfinding::AStar';

    sub new {
        my ($class, $graph) = @_;
        return bless { graph => $graph }, $class;
    }

    sub getSurrounding {
        my ($self, $id, $target) = @_;
        return $self->{graph}{$id} || [];
    }
}

# The goal is discovered while expanding "start", but "detour" has a
# lower f-score and is still ahead of it in OPEN. Stop after one expansion.
{
    my $map = 'AI::Pathfinding::AStar::TestMap'->new({
        start => [
            [ 'goal',   10, 0 ],
            [ 'detour',  1, 0 ],
        ],
        detour => [],
    });

    my $state = $map->findPathIncr('start', 'goal', undef, 2);

    ok(!$state->{done}, 'discovered goal is not reported done before finalization');
    is_deeply(
        $state->{path},
        [],
        'partial search does not return a path to an unfinalized goal'
    );
}

# The goal is not discovered yet. A partial search should return no path,
# rather than the current best OPEN node as if it were a goal path.
{
    my $map = 'AI::Pathfinding::AStar::TestMap'->new({
        start => [
            [ 'next', 1, 0 ],
        ],
        next => [],
    });

    my $state = $map->findPathIncr('start', 'goal', undef, 1);

    ok(!$state->{done}, 'undiscovered goal is not reported done');
    is_deeply(
        $state->{path},
        [],
        'partial search with no discovered goal returns an empty path'
    );
}

done_testing();
