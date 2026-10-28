#!/usr/bin/perl
use warnings;
use strict;

use Test::More tests => 1;

{
    package AI::Pathfinding::AStar::TestMap;
    use parent 'AI::Pathfinding::AStar';

    sub new {
        my ($class, $graph) = @_;
        bless { graph => $graph }, $class
    }

    sub getSurrounding {
        my ($self, $id, $target) = @_;
        return $self->{graph}{$id} || []
    }
}

my $map = 'AI::Pathfinding::AStar::TestMap'->new({
    start => [
        [ 'a', 1, 0 ],
    ],
    a => [
        [ 'x', 19, 100 ], # x first discovered at g=20, f=120
        [ 'p',  3,  97 ], # p: g=4, f=101
        [ 'q',  1, 100 ], # q: g=2, f=102
    ],
    p => [
        [ 'x', 1, 100 ],  # improves x to g=5
    ],
    q => [
        [ 'x', 1, 100 ],  # would improve x again to g=3
    ],
    x => [
        [ 'goal', 100, 0 ],
    ],
});

my $path = $map->findPath('start', 'goal');

is_deeply(
    $path,
    [ 'start', 'a', 'q', 'x', 'goal' ],
    'A* finds the optimal path'
);

done_testing();
