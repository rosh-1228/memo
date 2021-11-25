#!/bin/bash

echo "******************************************"
echo "*****bundle exec ruby get_top_test.rb*****"
echo "******************************************"
bundle exec ruby test/get_top_test.rb
echo;
echo "********************************************"
echo "*****bundle exec ruby post_memo_test.rb*****"
echo "********************************************"
bundle exec ruby test/post_memo_test.rb
echo;
echo "*******************************************"
echo "*****bundle exec ruby get_memo_test.rb*****"
echo "*******************************************"
bundle exec ruby test/get_memo_test.rb
echo;
echo "***************************************************"
echo "*****bundle exec ruby get_memo_context_test.rb*****"
echo "***************************************************"
bundle exec ruby test/get_memo_context_test.rb
echo;
echo "*****************************************************"
echo "*****bundle exec ruby patch_memo_context_test.rb*****"
echo "*****************************************************"
bundle exec ruby test/patch_memo_context_test.rb
echo;
echo "*****************************************"
echo "*****bundle exec ruby delete_memo.rb*****"
echo "*****************************************"
bundle exec ruby test/delete_memo.rb
echo;
echo "*************************************************"
echo "*****bundle exec ruby test/not_found_test.rb*****"
echo "*************************************************"
bundle exec ruby test/not_found_test.rb
