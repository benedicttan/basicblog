# get '/' do
#   # Look in app/views/index.erb
#   # erb :index
# end

post "/" do
  Post.create(title: params[:title], body: params[:body])

  tags = params[:tags].downcase.split(",").map(&:strip)
  tags.each do |tag|
    Tag.create(title: tag) if Tag.where(title: tag).empty?

    this_post_id = Post.last.id
    this_tag_id = Tag.where(title: tag).first.id

    PostTag.create(post_id: this_post_id, tag_id: this_tag_id)
  end

  @message = "New post created"

  erb :index
end


get "/post/:id" do
  @post = Post.find(params[:id])
  erb :post
end

post "/delete" do
  Post.find(params[:id]).destroy
  PostTag.where(post_id: params[:id]).destroy_all
  @message = "Post " << params[:id] << " deleted"
  erb :index
end

post "/update" do
  this_post = Post.find(params[:id])

  this_post.title = params[:title]
  this_post.body = params[:body]

  PostTag.where(post_id: this_post.id).destroy_all


  tags = params[:tags].downcase.split(",")
  tags.each do |tag|
    tag.lstrip.chop
    Tag.create(title: tag) if Tag.where(title: tag).empty?

    # this_post_id = Post.last.id
    this_tag = Tag.where(title: tag).first

    PostTag.create(post_id: this_post.id, tag_id: this_tag.id)
  end

  this_post.save

  @message = "Post updated"
  erb :index
end