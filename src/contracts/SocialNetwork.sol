pragma solidity ^0.5.0;

contract SocialNetwork {
    string public name;
    uint public postCount = 0;
    mapping(uint => Post) public posts;

    struct Post {
        uint id;
        string content;
        uint tipAmount;
        address payable author;
    }

    event PostCreated(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    event PostTipped(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    constructor() public {
        name = "Dapp University Social Network";
    }

    function createPost(string memory _content) public {
        require(bytes(_content).length > 0);                                     // Require valid content
        postCount ++;                                                            // Increment the post count
        posts[postCount] = Post(postCount, _content, 0, msg.sender);             // Create the post
        emit PostCreated(postCount, _content, 0, msg.sender);                    // Trigger event
    }

    function tipPost(uint _id) public payable {
        require(_id > 0 && _id <= postCount);                                    // Make sure the id is valid
        Post memory _post = posts[_id];                                          // Fetch the post
        address payable _author = _post.author;                                  // Fetch the author
        address(_author).transfer(msg.value);                                    // Pay the author by sending them Ether
        _post.tipAmount = _post.tipAmount + msg.value;                           // Increment the tip amount
        posts[_id] = _post;                                                      // Update the post
        emit PostTipped(postCount, _post.content, _post.tipAmount, _author);     // Trigger an event
    }
    
}