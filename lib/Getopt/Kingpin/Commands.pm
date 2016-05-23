package Getopt::Kingpin::Commands;
use 5.008001;
use strict;
use warnings;
use Moo;
use Getopt::Kingpin::Command;
use Carp;

our $VERSION = "0.01";

has _commands => (
    is => 'rw',
    default => sub {return []},
);

sub add {
    my $self = shift;
    my $hash = {@_};
    my ($name, $description, $parent) = ($hash->{name}, $hash->{description}, $hash->{parent});

    my $command = Getopt::Kingpin::Command->new(_name => $name, _description => $description, _parent => $parent);
    push @{$self->_commands}, $command;

    return $command;
}

sub count {
    my $self = shift;
    return scalar @{$self->_commands};
}

sub get {
    my $self = shift;
    my ($name) = @_;
    foreach my $cmd (@{$self->_commands}) {
        if ($cmd->_name eq $name) {
            return $cmd;
        }
    }
    return;
}

sub get_all {
    my $self = shift;
    return @{$self->_commands};
}

sub help {
    my $self = shift;
    my $ret = "";

    $ret .= "Commands:\n";

    foreach my $cmd ($self->get_all) {
        $ret .= sprintf "  %s\n", $cmd->help_short;
        $ret .= sprintf "    %s\n", $cmd->_description;
        $ret .= sprintf "\n";
    }

    return $ret;
}

1;
__END__

=encoding utf-8

=head1 NAME

Getopt::Kingpin::Flags - command line option object

=head1 SYNOPSIS

    use Getopt::Kingpin::Flags;
    my $flags = Getopt::Kingpin::Flags->new;
    $flags->add(
        name        => 'help',
        description => 'Show context-sensitive help.',
    )->bool();

=head1 DESCRIPTION

Getopt::Kingpin::Flags は、Getopt::Kingpinから使用するモジュールです。
Flagを集合として扱います。

=head1 METHOD

=head2 new()

Create Getopt::Kingpin::Flags object.

=head2 add(name => $name, description => $description)

$name と $description をもつGetopt::Kingpin::Flagを生成し、管理します。

=head2 get($name)

$name で指定したGetopt::Kingpin::Flagを取り出します。

=head2 keys()

定義されている$nameの一覧の出力します。
add()した順で出力されます。

=head2 values()

定義されているGetopt::Kingpin::Flagをすべて出力します。
add()した順で出力されます。

=head2 _help_length()

short_name、name、descriptionの文字列長を返します。

=head2 help()

ヘルプを表示します。

=head1 LICENSE

Copyright (C) sago35.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sago35 E<lt>sago35@gmail.comE<gt>

=cut

