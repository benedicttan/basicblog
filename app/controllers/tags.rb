# get '/' do
#   # Look in app/views/index.erb
#   # erb :index
# end

get "/tag/:title" do
  def all_posts
    this_tag_id = Tag.where(title: params[:title]).first.id

    this_posttags = PostTag.where(tag_id: this_tag_id)

    posts_array = []
    this_posttags.each do |posttag|
      posts_array << Post.find(posttag.post_id)
    end

    posts_array

  end
  erb :tag
end