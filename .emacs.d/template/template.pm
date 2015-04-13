package A;
use strict;
use warnings;
use utf8;

use Class::Accessor::Lite (
    new => 1,
    rw  => [ qw(foo bar) ],
    ro => [ qw(baz) ],
    wo => [ qw(hoge) ],
);

# sub new {
#     my ($class, $args) = @_;
#     bless $args, $class;
# }

sub init {
    my ($self, $params) = shift;
    $self->foo($params->{foo});
}

1;
