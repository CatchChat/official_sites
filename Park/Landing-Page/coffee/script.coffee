$("#cover .hint").click ->
    $("body").animate {scrollTop: $("#cover").height()}, 800

text = [
    {
        title: "附近频道",
        desc: "附近频道附近频道附近频道附近频道附近频道附近频道附近频道附近频道附近频道附近频道"
    },
    {
        title: "群组",
        desc: "群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组群组"
    },
    {
        title: "聊天聊天",
        desc: "附近频道附近频道附近频道附近频道附近频道附近频道附近频道附近频道附近频道附近频道"
    },
    {
        title: "主页",
        desc: "主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页主页"
    }
]

$(".descs").append "<h1>" + text[0].title + "</h1>" +
                    "<h2>" + text[0].desc + "</h2>"


GoToPage = (index) ->
    duration = 250
    $(".screen").animate {scrollLeft: 320 * index }, duration
    $("#screenshot .icons li.active").removeClass "active"
    $("#screenshot .icons li").eq(index).addClass "active"
    $(".bigicon").css("background-position-x", -(100 * index) * 1.5 )
    $(".descs h1").html(text[index].title)
    $(".descs h2").html(text[index].desc)


$("#screenshot .icons li").click ->
    index = $(this).index()
    GoToPage(index)


$(".iphone i.right").click ->
    page = $(".screen").scrollLeft() / 320

    if page < 3
        GoToPage(page + 1)
    else
        GoToPage(0)


$(".iphone i.left").click ->
    page = $(".screen").scrollLeft() / 320

    if page > 0
        GoToPage(page - 1)
    else
        GoToPage(3)





