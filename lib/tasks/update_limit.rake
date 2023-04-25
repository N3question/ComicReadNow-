namespace :update_limit do
    desc 'update limit' # desc内容説明部分
    task reset: :environment do
        User.update_all(
            remaining_total_update_limit: 100
            )
        Comic.update_all(
            remaining_one_comic_update_limit: 1
            )
    end
end
