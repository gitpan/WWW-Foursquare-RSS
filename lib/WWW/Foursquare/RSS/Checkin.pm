package WWW::Foursquare::RSS::Checkin;

use strict;
use warnings;
use Carp;
use DateTime    qw();
use Date::Parse qw(str2time);

our $VERSION = '0.01';

sub new
{
    my ($class, $data) = @_;
    my $self = { rss_data => $data };
    bless $self, $class;
    return $self;
};

=head1 NAME

WWW::Foursquare::RSS::Checkin - Checkin object for L<WWW::Foursquare::RSS>

=head1 DESCRIPTION

See L<WWW::Foursquare::RSS>. This module is useless on its own.

=head1 METHODS

=head2 venue_id

Returns the Foursquare venue ID of the venue that was checked in to.

=cut

sub venue_id
{
    my $self = shift;

    return $self->{venue_id} if $self->{venue_id};

    my $link = $self->{rss_data}{'link'};
    if ($link =~ /venue\/(\d+)/) {
        $self->{venue_id} = $1;
    }

    return $self->{venue_id};
}

=head2 venue_url

Returns the URL for the Foursquare page representing the venue that was checked in to.

=cut

sub venue_url
{
    my $self = shift;
    my $venue_id = $self->venue_id or return;
    return "http://www.foursquare.com/venue/$venue_id";
}

=head2 venue_name

Returns the name of the venue that was checked in to.

=cut

sub venue_name
{
    my $self = shift;
    return $self->{rss_data}{title};
}

=head2 datetime

Returns a DateTime object representing the date/time of the checkin.

=cut

sub datetime
{
    my $self = shift;

    return $self->{datetime} if $self->{datetime};

    my $time = $self->{rss_data}{pubDate} or return;
       $time = DateTime->from_epoch(epoch => str2time($time));
    return $time;
}

=head1 DEPENDENCIES

DateTime, Date::Parse

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

