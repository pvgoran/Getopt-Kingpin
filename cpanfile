requires 'perl', '5.010001';
requires 'Object::Simple';
requires 'Path::Tiny';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Exception';
    requires 'Test::Trap';
    requires 'Digest::MD5';
};

