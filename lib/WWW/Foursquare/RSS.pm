package WWW::Foursquare::RSS;

use strict;
use warnings;
use Carp;
use LWP::Simple qw(get);
use XML::Simple qw(XMLin);
use aliased 'WWW::Foursquare::RSS::Checkin';

our $VERSION = '0.01';

=head1 NAME

WWW::Foursquare::RSS - Perl interface to the Foursquare.com RSS feeds

=head1 SYNOPSIS

  use WWW::Foursquare::RSS;

  my $key        = '1234567890';
  my $foursquare = WWW::Foursquare::RSS->new($key);
  my @checkins   = $foursquare->get_checkins(count => 1);
  my $checkin    = shift @checkins;
  print "I was last seen at " . $checkin->venue_name;

=head1 DESCRIPTION

This module provides an object-oriented Perl interface to the Foursquare.com RSS feeds.

Note that this module isn't intended for use in production applications - that's what the official Foursquare API is for. This is just for Perl hackers who want easy access to their checkin history.

=head1 METHODS

=head2 new

Returns a new instance of WWW::Foursquare. Accepts (and requires) your private token as a parameter.

You can find your private token at http://foursquare.com/feeds/ - it is the alphanumeric string between "/history/" and ".rss" in the RSS feed link.

=cut

sub new
{
    my ($class, $key) = @_;
    croak "You must specify your API key" unless $key;
    my $self = { key => $key };
    bless $self, $class;
    return $self;
};

=head2 get_checkins

Returns an array of L<WWW::Foursquare::RSS::Checkin> objects representing your checkins.

Accepts the following optional parameters:

count - The number of checkins to return (defaults to 25)

=cut

sub get_checkins
{
    my ($self, %params) = @_;
    my $key   = $self->{key};
    my $count = $params{count} || 25;
    my $uri   = "http://feeds.foursquare.com/history/$key.rss?count=$count";
    my $xml   = get($uri);
    my $data  = XMLin($xml);
    my $items = $data->{channel}{item} || [];
    return map { Checkin->new($_) } @$items;
}

=head1 DEPENDENCIES

DateTime, Date::Parse, XML::Simple, LWP::Simple

=head1 DISCLAIMER

The author of this module is not affiliated in any way with Foursquare.

Users of this module must be sure to follow the Foursquare terms of service.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 Michael Aquilina. All rights reserved.

This code is free software; you can redistribute it and/or modify it under the same terms as Perl
itself.

=head1 AUTHOR

Michael Aquilina, aquilina@cpan.org

=cut

1;

