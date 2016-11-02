use strict;
use Test::More 0.98;
use Test::Exception;
use Test::Trap;
use Getopt::Kingpin;
use Getopt::Kingpin::Command;
use File::Basename;

subtest 'command (flag)' => sub {
    local @ARGV;
    push @ARGV, qw(post --server 127.0.0.1 --image=abc.jpg);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $image = $post->flag("image", "")->file();

    my $cmd = $kingpin->parse;

    is $cmd, "post";
    is $cmd->flags->get("server"), "127.0.0.1";
    is $cmd->flags->get("image"), "abc.jpg";

    is ref $post, "Getopt::Kingpin::Command";
    is ref $server, "Getopt::Kingpin::Flag";
    is ref $image, "Getopt::Kingpin::Flag";

    is $server, "127.0.0.1";
    is $image, "abc.jpg";
};

subtest 'command (arg)' => sub {
    local @ARGV;
    push @ARGV, qw(post 127.0.0.1 abc.jpg);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->arg("server", "")->string();
    my $image = $post->arg("image", "")->file();

    my $cmd = $kingpin->parse;

    is $cmd, "post";
    is $cmd->args->get("server"), "127.0.0.1";
    is $cmd->args->get("image"), "abc.jpg";

    is ref $post, "Getopt::Kingpin::Command";
    is ref $server, "Getopt::Kingpin::Arg";
    is ref $image, "Getopt::Kingpin::Arg";

    is $server, "127.0.0.1";
    is $image, "abc.jpg";
};

subtest 'command (flag and arg)' => sub {
    local @ARGV;
    push @ARGV, qw(post --server 127.0.0.1 abc.jpg);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $image = $post->arg("image", "")->file();

    $kingpin->parse;

    is ref $post, "Getopt::Kingpin::Command";
    is ref $server, "Getopt::Kingpin::Flag";
    is ref $image, "Getopt::Kingpin::Arg";

    is $server, "127.0.0.1";
    is $image, "abc.jpg";
};

subtest 'command help' => sub {
    local @ARGV;
    push @ARGV, qw(--help);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $image = $post->arg("image", "")->file();

    my $expected = sprintf <<'...', basename($0);
usage: %s [<flags>] <command> [<args> ...]

Flags:
  --help  Show context-sensitive help.

Commands:
  help [<command>...]
    Show help.

  post [<flags>] [<image>]
    post image


...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help' => sub {
    local @ARGV;
    push @ARGV, qw(--help);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $image = $post->arg("image", "")->file();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s [<flags>] <command> [<args> ...]

Flags:
  --help  Show context-sensitive help.

Commands:
  help [<command>...]
    Show help.

  post [<flags>] [<image>]
    post image

  get
    get image


...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help' => sub {
    local @ARGV;
    push @ARGV, qw(--help);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s [<flags>] <command> [<args> ...]

Flags:
  --help  Show context-sensitive help.

Commands:
  help [<command>...]
    Show help.

  post [<flags>]
    post image

  get
    get image


...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 2' => sub {
    local @ARGV;
    push @ARGV, qw(help);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s [<flags>] <command> [<args> ...]

Flags:
  --help  Show context-sensitive help.

Commands:
  help [<command>...]
    Show help.

  post [<flags>]
    post image

  get
    get image


...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 3' => sub {
    local @ARGV;
    push @ARGV, qw(--help post);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s post [<flags>]

post image

Flags:
  --help           Show context-sensitive help.
  --server=SERVER

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 3' => sub {
    local @ARGV;
    push @ARGV, qw(post --help);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s post [<flags>]

post image

Flags:
  --help           Show context-sensitive help.
  --server=SERVER

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 3' => sub {
    local @ARGV;
    push @ARGV, qw(help post);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s post [<flags>]

post image

Flags:
  --help           Show context-sensitive help.
  --server=SERVER

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 3' => sub {
    local @ARGV;
    push @ARGV, qw(help post --server=SERVER);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s post [<flags>]

post image

Flags:
  --help           Show context-sensitive help.
  --server=SERVER

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 3' => sub {
    local @ARGV;
    push @ARGV, qw(--help post);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s post [<flags>]

post image

Flags:
  --help           Show context-sensitive help.
  --server=SERVER

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 4' => sub {
    local @ARGV;
    push @ARGV, qw(help get);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "")->string();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s get

get image

Flags:
  --help  Show context-sensitive help.

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 5' => sub {
    local @ARGV;
    push @ARGV, qw(--help post);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "");
    my $server = $post->arg("server", "server address")->string();
    my $get  = $kingpin->command("get", "get image");

    my $expected = sprintf <<'...', basename($0);
usage: %s post [<server>]

Flags:
  --help  Show context-sensitive help.

Args:
  [<server>]  server address

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 6' => sub {
    local @ARGV;
    push @ARGV, qw(--help);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "server address")->string();
    my $get  = $kingpin->command("get", "get image");
    my $xyz  = $get->command("xyz", "set xyz");

    my $expected = sprintf <<'...', basename($0);
usage: %s [<flags>] <command> [<args> ...]

Flags:
  --help  Show context-sensitive help.

Commands:
  help [<command>...]
    Show help.

  post [<flags>]
    post image

  get xyz
    set xyz


...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 6' => sub {
    local @ARGV;
    push @ARGV, qw(--help);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "server address")->string();
    my $get  = $kingpin->command("get", "get image");
    my $xyz  = $get->command("xyz", "set xyz");
    my $abc  = $get->command("abc", "set abc");

    my $expected = sprintf <<'...', basename($0);
usage: %s [<flags>] <command> [<args> ...]

Flags:
  --help  Show context-sensitive help.

Commands:
  help [<command>...]
    Show help.

  post [<flags>]
    post image

  get xyz
    set xyz

  get abc
    set abc


...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 6' => sub {
    local @ARGV;
    push @ARGV, qw(--help get);

    my $kingpin = Getopt::Kingpin->new();
    my $post = $kingpin->command("post", "post image");
    my $server = $post->flag("server", "server address")->string();
    my $get  = $kingpin->command("get", "get image");
    my $xyz  = $get->command("xyz", "set xyz");

    my $expected = sprintf <<'...', basename($0);
usage: %s get <command> [<args> ...]

get image

Flags:
  --help  Show context-sensitive help.

Subcommands:
  get xyz
    set xyz

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 7' => sub {
    local @ARGV;
    push @ARGV, qw(--help register);

    my $kingpin = Getopt::Kingpin->new;

    my $register      = $kingpin->command('register', 'Register a new user.');
    my $register_nick = $register->arg('nick', 'Nickname for user.')->required->string;
    my $register_name = $register->arg('name', 'Name for user.')->required->string;

    my $post        = $kingpin->command('post', 'Post a message to a channel.');
    my $postImage   = $post->flag('image', 'Image to post.')->file;
    my $postChannel = $post->arg('channel', 'Channel to post to.')->required->string;
    my $postText    = $post->arg('text', 'Text to post.')->string_list;

    my $expected = sprintf <<'...', basename($0);
usage: %s register <nick> <name>

Register a new user.

Flags:
  --help  Show context-sensitive help.

Args:
  <nick>  Nickname for user.
  <name>  Name for user.

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 7-2' => sub {
    local @ARGV;
    push @ARGV, qw(register --help);

    my $kingpin = Getopt::Kingpin->new;

    my $register      = $kingpin->command('register', 'Register a new user.');
    my $register_nick = $register->arg('nick', 'Nickname for user.')->required->string;
    my $register_name = $register->arg('name', 'Name for user.')->required->string;

    my $post        = $kingpin->command('post', 'Post a message to a channel.');
    my $postImage   = $post->flag('image', 'Image to post.')->file;
    my $postChannel = $post->arg('channel', 'Channel to post to.')->required->string;
    my $postText    = $post->arg('text', 'Text to post.')->string_list;

    my $expected = sprintf <<'...', basename($0);
usage: %s register <nick> <name>

Register a new user.

Flags:
  --help  Show context-sensitive help.

Args:
  <nick>  Nickname for user.
  <name>  Name for user.

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 7-3' => sub {
    local @ARGV;
    push @ARGV, qw(help register);

    my $kingpin = Getopt::Kingpin->new;

    my $register      = $kingpin->command('register', 'Register a new user.');
    my $register_nick = $register->arg('nick', 'Nickname for user.')->required->string;
    my $register_name = $register->arg('name', 'Name for user.')->required->string;

    my $post        = $kingpin->command('post', 'Post a message to a channel.');
    my $postImage   = $post->flag('image', 'Image to post.')->file;
    my $postChannel = $post->arg('channel', 'Channel to post to.')->required->string;
    my $postText    = $post->arg('text', 'Text to post.')->string_list;

    my $expected = sprintf <<'...', basename($0);
usage: %s register <nick> <name>

Register a new user.

Flags:
  --help  Show context-sensitive help.

Args:
  <nick>  Nickname for user.
  <name>  Name for user.

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 8' => sub {
    local @ARGV;
    push @ARGV, qw(--help post);

    my $kingpin = Getopt::Kingpin->new;

    my $register      = $kingpin->command('register', 'Register a new user.');
    my $register_nick = $register->arg('nick', 'Nickname for user.')->required->string;
    my $register_name = $register->arg('name', 'Name for user.')->required->string;

    my $post        = $kingpin->command('post', 'Post a message to a channel.');
    my $postImage   = $post->flag('image', 'Image to post.')->file;
    my $postChannel = $post->arg('channel', 'Channel to post to.')->required->string;
    my $postText    = $post->arg('text', 'Text to post.')->string_list;

    my $expected = sprintf <<'...', basename($0);
usage: %s post [<flags>] <channel> [<text>...]

Post a message to a channel.

Flags:
  --help         Show context-sensitive help.
  --image=IMAGE  Image to post.

Args:
  <channel>  Channel to post to.
  [<text>]   Text to post.

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 8-2' => sub {
    local @ARGV;
    push @ARGV, qw(post --help);

    my $kingpin = Getopt::Kingpin->new;

    my $register      = $kingpin->command('register', 'Register a new user.');
    my $register_nick = $register->arg('nick', 'Nickname for user.')->required->string;
    my $register_name = $register->arg('name', 'Name for user.')->required->string;

    my $post        = $kingpin->command('post', 'Post a message to a channel.');
    my $postImage   = $post->flag('image', 'Image to post.')->file;
    my $postChannel = $post->arg('channel', 'Channel to post to.')->required->string;
    my $postText    = $post->arg('text', 'Text to post.')->string_list;

    my $expected = sprintf <<'...', basename($0);
usage: %s post [<flags>] <channel> [<text>...]

Post a message to a channel.

Flags:
  --help         Show context-sensitive help.
  --image=IMAGE  Image to post.

Args:
  <channel>  Channel to post to.
  [<text>]   Text to post.

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

subtest 'command help 8-3' => sub {
    local @ARGV;
    push @ARGV, qw(help post);

    my $kingpin = Getopt::Kingpin->new;

    my $register      = $kingpin->command('register', 'Register a new user.');
    my $register_nick = $register->arg('nick', 'Nickname for user.')->required->string;
    my $register_name = $register->arg('name', 'Name for user.')->required->string;

    my $post        = $kingpin->command('post', 'Post a message to a channel.');
    my $postImage   = $post->flag('image', 'Image to post.')->file;
    my $postChannel = $post->arg('channel', 'Channel to post to.')->required->string;
    my $postText    = $post->arg('text', 'Text to post.')->string_list;

    my $expected = sprintf <<'...', basename($0);
usage: %s post [<flags>] <channel> [<text>...]

Post a message to a channel.

Flags:
  --help         Show context-sensitive help.
  --image=IMAGE  Image to post.

Args:
  <channel>  Channel to post to.
  [<text>]   Text to post.

...

    trap {$kingpin->parse};
    is $trap->exit, 0;
    is $trap->stdout, $expected;
};

done_testing;

