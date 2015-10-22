# set up initial admin user
User.create(name: 'admin', username: 'admin', email: 'admin@railsconfevents.com', provider: 'seed', uid: 'QWER3704TTQO')

railsconf_2016 = Conference.create(starting_at: '2016-05-04', ending_at: '2016-05-06', allow_starting_at: '2016-05-02',
                                   allow_ending_at: '2016-05-07', year: 2016, creator_user_id: 1, timezone: 'Central Time (US & Canada)')