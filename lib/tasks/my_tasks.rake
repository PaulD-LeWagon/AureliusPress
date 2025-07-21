namespace :mt do
  desc "Tear down and rebuild the database. Then run all migrations."
  task :rebuild => :environment do
    puts "Starting database rebuild..."
    system("rails db:drop")
    puts "Database dropped."
    system("rails db:create")
    puts "Database created."
    system("rails db:migrate")
    puts "DB migrations completed."
    puts "Task completed!"
  end

  desc "Rebuild and seed the database."
  task :rebuild_seed => :environment do
    puts "Starting database rebuild and seed..."
    system("rails db:drop db:create db:migrate db:seed")
    puts "Database rebuild and seed complete!"
  end

  desc "Generates a sample User a BlogPost with 3 Comments for the development environment."
  task :gen_com => :environment do
    puts "Generating a BlogPost with 3 Comments..."

    # Ensure you have some existing BlogPost for comments
    # Or create one if none exist

    author = User.first || FactoryBot.create(:user)
    commenter = User.second || FactoryBot.create(:user)

    puts "Using User: #{author.id} #{author.username} for comments."

    blog_post = BlogPost.first || BlogPost.create!(
      title: "Sample Blog Post",
      user: author,
    )

    puts "Using BlogPost: #{blog_post.id} #{blog_post.title} for comments."

    3.times do |i|
      comment = Comment.create!(
        commentable: blog_post,
        user: commenter,
        status: :published,
        visibility: :public_to_www,
        content: "This is a sample comment #{i + 1} on the blog post '#{blog_post.title}'",
      )
      puts "Created Comment #{i + 1}: #{comment.id} by\
          #{comment.user.username} on\
          BlogPost: #{blog_post.title} by\
          #{blog_post.user.username}"
    end

    puts "Created BlogPost: #{blog_post.id} #{blog_post.title} with #{blog_post.comments.count} comments."

    puts "Sample comments generation complete!"
  end

  desc "Generates sample nested comments for the development environment."
  task :generate_comments => :environment do
    puts "Generating sample comments..."

    # Ensure you have some existing BlogPost for comments
    # Or create one if none exist
    blog_post = BlogPost.first || FactoryBot.create(:blog_post, comments_enabled: true)
    user = User.first || FactoryBot.create(:user)

    puts "Using BlogPost: #{blog_post.id} #{blog_post.title} for comments."
    puts "Using User: #{user.id} #{user.username} for comments."

    # Create top-level comments on the blog post
    5.times do |i|
      top_level_comment = FactoryBot.create(:comment,
                                            commentable: blog_post,
                                            user: user,
                                            title: "Top-level Comment #{i + 1} on #{blog_post.title}")
      puts "  Created top-level comment: #{top_level_comment.user.username} doc_id: #{top_level_comment.commentable.id} #{top_level_comment.title}"

      # Create child comments for each top-level comment
      3.times do |j|
        child_comment = FactoryBot.create(:comment,
                                          :on_another_comment,
                                          commentable: top_level_comment,
                                          user: user,
                                          title: "Child Comment #{j + 1} on #{top_level_comment.title}")
        puts "    Created child comment: #{child_comment.title}"

        # Create grandchild comments for some child comments (optional, for deeper nesting)
        if j == 0 # Only for the first child of each top-level comment
          2.times do |k|
            grandchild_comment = FactoryBot.create(:comment,
                                                   :on_another_comment,
                                                   commentable: child_comment,
                                                   user: user,
                                                   title: "Grandchild Comment #{k + 1} on #{child_comment.title}")
            puts "      Created grandchild comment: #{grandchild_comment.title}"
          end
        end
      end
    end

    puts "Sample comments generation complete!"
  end
end
