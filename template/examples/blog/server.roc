app "server"
    packages { pf: "https://github.com/roc-lang/basic-webserver/releases/download/0.3.0/gJOTXTeR3CD4zCbRqK7olo4edxQvW5u3xGL-8SSxDcY.tar.br" }
    imports [
        pf.Task.{ Task },
        pf.Http.{ Request, Response },
        Pages,
    ]
    provides [main] to pf

main = \req ->
    when Str.split req.url "/" |> List.dropFirst 1 is
        ["posts", slug] ->
            maybePost = List.findFirst posts \post ->
                post.slug == slug
            when maybePost is
                Err _ -> notFound
                Ok post ->
                    Pages.blogPost {
                        post,
                    }
                    |> success

        [""] ->
            Pages.home {
                posts,
            }
            |> success

        _ -> notFound

posts = [
    {
        title: "How to write a template engine in Roc",
        slug: "template-engine",
        content: [Text "Roc's type inference shines through here. It makes it easy to write a template language with compile time errors while having the same feel as dynamic languages."],
    },
    {
        title: "My story: thinking of blog ideas for this example",
        slug: "my-story",
        content: [Text "What follows is a code block:", Code "[1,2,3] |> List.map \\x -> x * x"],
    },
    {
        title: "The last blog post",
        slug: "fin",
        content: [Text "Here's an image", Image "https://www.roc-lang.org/favicon.svg"],
    },
]

notFound = Task.ok {
    status: 404,
    headers: [],
    body: [],
}

success = \body ->
    Task.ok {
        status: 200,
        headers: [Http.header "Content-Type" "text/html"],
        body: body |> Str.toUtf8,
    }
