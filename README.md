# CA Bundle Test

A small test script to try and debug certificate verification problems.

## Running

Install dependencies via bundler:

    bundle install

Export an API key to your environment (a testmode API key is fine):

    export STRIPE_API_KEY=sk_test_...

Then run:

    bundle exec ruby test.rb
