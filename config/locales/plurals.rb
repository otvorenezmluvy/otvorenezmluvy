# https://github.com/svenfuchs/i18n/blob/master/test/test_data/locales/plurals.rb
{
    :sk => {
        :i18n => {
            :plural => {
                :keys => [:one, :few, :other],
                :rule => lambda { |n| n == 1 ? :one : [2, 3, 4].include?(n) ? :few : :other }
            }
        }
    }
}
