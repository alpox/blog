# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Web.Repo.insert!(%Web.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Web.Repo
alias Web.Post

Repo.insert!(%Post {
    title: "This is my first post!",
    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris semper massa vitae justo porttitor venenatis. Vestibulum malesuada massa purus, vel dapibus sem consequat vitae. Ut ultricies metus nibh, dignissim semper nunc luctus ac. Donec convallis maximus sem ut convallis. Sed aliquam nisi ac risus consequat, at pulvinar nisi tristique. Maecenas porta lacus felis, nec congue nulla malesuada facilisis. Quisque tristique lectus arcu, nec varius mauris varius a. Ut aliquam dolor mauris, faucibus gravida velit pulvinar vitae. Duis imperdiet laoreet ante vitae congue. Aliquam erat volutpat. Curabitur mattis ligula eu felis fermentum, nec accumsan lacus pretium.

Quisque nec libero egestas, congue ipsum vitae, commodo nisi. Praesent sed enim eu odio auctor vehicula. Integer id maximus odio. Cras aliquam nibh arcu, a laoreet justo molestie eu. Donec vitae varius arcu, sed aliquam odio. Phasellus congue diam convallis dapibus imperdiet. Sed pretium, libero a blandit egestas, urna orci ullamcorper sapien, non congue leo leo sed lectus. Praesent egestas purus vitae rhoncus euismod. In id venenatis turpis, eu consectetur massa. Integer sit amet maximus turpis. Nunc lobortis malesuada justo nec posuere. Nullam aliquet eu ante ac vehicula. Sed id massa lectus. Pellentesque porttitor, urna quis tincidunt scelerisque, est massa accumsan justo, at posuere sapien mauris vitae libero. Sed aliquam orci at nulla gravida euismod."
})

Repo.insert!(%Post {
    title: "This is my second post!",
    content: "
Tables can look like this:

size  material      color
----  ------------  ------------
9     leather       brown
10    hemp canvas   natural
11    glass         transparent
"
})

Repo.insert!(%Post {
    title: "This is a line block!",
    content: "
Here's a \"line block\":

| Line one
|   Line too
| Line tree
"
})