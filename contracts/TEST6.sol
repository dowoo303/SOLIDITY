// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.18;

/*

안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
안건들을 모아놓은 자료구조도 구현하세요.

사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

* 사용자 등록 기능 - 사용자를 등록하는 기능
* 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
* 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
* 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
* 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
-------------------------------------------------------------------------------------------------
* 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 전체의 70% 그리고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각

*/

contract TEST6 {
    // 안건 진행 과정 체크
    enum paperStatus {
        voting,
        pass,
        reject
    }

    // 안건
    struct paper {      
        uint number;
        string title;
        string content;
        address proposer;
        uint agree;
        uint disagree;
        paperStatus status;
    }

    // 안건들을 모아놓은 자료구조도 구현하세요. (array mapping)
    mapping(string => paper) paperList;

    // 투표할 유저들
    struct User {
        string name;
        address account;
        paper[] myPapers;      // 자신이 만든 안건
        mapping(string => paper) complete;       // 자신이 투표한 안건
        mapping(string => bool) choiced;
    }


    // * 사용자 등록 기능 - 사용자를 등록하는 기능
    mapping(address => User) userList;
    uint userCount;

    function setUser(string memory name) public {
        require(userList[msg.sender].account != msg.sender, "You already User");

        userList[msg.sender].name = name;
        userList[msg.sender].account = msg.sender;
        userCount++;
    }


    // * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    function vote(string memory _title, bool _choice) public {
        // 재투표 불가
        require(userList[msg.sender].complete[_title].number != paperList[_title].number, "No revote OR Not exist paper");
        // 유저 맞음?
        require(userList[msg.sender].account == msg.sender, "You are no user");   
        // 존재하는 안건임?
        require(paperList[_title].number != 0, "Not exist paper");

        if(_choice == true) {
            // 찬성에 투표를 했다면   
            paperList[_title].agree +=1;        // 안건 동의자수 1 증가
            userList[msg.sender].choiced[_title] = true;    // 이 안건은 동의했다고 유저 정보에 저장
        } else {
            // 반대에 투표를 했다면
            paperList[_title].disagree +=1;
            userList[msg.sender].choiced[_title] = false;
        }
        userList[msg.sender].complete[_title] = paperList[_title];      // 유저정보에 투표한 안건 추가
        
    }

    // * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    uint count=1;   // 0번이면 재투표불가 require에서 오류 발생함

    function makePaper(string memory _title, string memory _content) public {
        require(userList[msg.sender].account == msg.sender, "You are no user");

        paperList[_title] = paper(count++, _title, _content, msg.sender, 0, 0, paperStatus.voting);
        userList[msg.sender].myPapers.push(paperList[_title]);
    }

    // * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    function getMyPaper() public view returns(paper[] memory) {
        return userList[msg.sender].myPapers;
    }


    // * 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
    function getPaper(string memory _title) public view returns(paper memory) {
        require(paperList[_title].number != 0, "Not exist paper");
        return paperList[_title];
    }


    // * 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 전체의 70% 그리고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
    function checkPaper(string memory _title) public returns(paperStatus) {
        require(paperList[_title].number != 0, "Not exist paper");

        // 전체의 70% 투표 해야함
        uint a = ((paperList[_title].agree + paperList[_title].disagree)*100) / userCount;
        // 투표자의 66% 이상이 찬성
        uint b = (paperList[_title].agree*100) / (paperList[_title].agree + paperList[_title].disagree);
        if ( a >= 70 && b >= 66)  {
            paperList[_title].status = paperStatus.pass;
        } else {
            paperList[_title].status = paperStatus.reject;
        }
        return paperList[_title].status;
    }
}







contract Q6 {
    struct poll {
        uint number;
        string title;
        string context;
        address by;
        uint pros;
        uint cons;
        pollStatus status;
    }

    // poll을 관리할 자료구조 , array or mapping
    mapping(string => poll) public polls;
    uint public count;

    enum votingStatus {
        notVoted,
        pro,
        con
    }

    enum pollStatus {
        ongoing,
        passed,
        rejected
    }

    struct user {
        uint number;
        string name;
        address addr;
        string[] suggested;
        mapping(string=>votingStatus) voted;
    }

    // user를 관리할 자료구조 , array or mapping
    user[] public Users;

    function getUsersLength() public view returns(uint) {
        return Users.length;
    }

    // user안에 mapping때문에 초기값 설정이 힘듬
    function pushUser(uint _number, string memory _name, address _addr) public {
        user storage _newuser = Users.push();
        Users[Users.length-1].number = _number;
        Users[Users.length-1].name = _name;
        Users[Users.length-1].addr = _addr;
    }

    // * 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
    function vote(uint number, string memory _title, bool _vote) public {
        require(Users[number].voted[_title]==votingStatus.notVoted); //투표자가 해당 안건에 대해서 투표를 안했어야 함
        // 찬성이냐, 반대이냐
        if(_vote==true) {
            polls[_title].pros++;
            Users[number].voted[_title] = votingStatus.pro;
        } else {
            polls[_title].cons++;
            Users[number].voted[_title] = votingStatus.con;
        }
    }

    // * 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
    // 인스턴스 컨트랙트의 mapping에는 접근 불가!
    // 이 함수에서는 msg.sender을 못쓰기 때문에 따로 받아와야함(여기서 msg.sender는 및 user컨트랙트의 주소임)
    function suggest(string memory _title, string memory _context, address _addr) public {      
        polls[_title] = poll(++count, _title, _context, _addr, 0, 0, pollStatus.ongoing);
    }

    // * 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
    function getPoll(string memory _title) public view returns(poll memory) {
        return polls[_title];
    }

}


contract User {
    Q6 polls;

    constructor(address _a) {
        polls = Q6(_a);
    }

    enum votingStatus {
        notVoted,
        pro,
        con
    }

    struct user {
        uint number;
        string name;
        address addr;
        string[] suggested;
        mapping(string=>votingStatus) voted;
    }

    // 접속한 유저 관리
    user MyAccount;

    // 인스턴스화 시켜서 배열을 사용할 경우 배열의 길이측정이나 push같은 작업은 인스턴스 대상 컨트랙트에서 함수를 만들어서 사용해야 오류 안남
    function setUser(string memory _name) public {
        (MyAccount.number, MyAccount.name, MyAccount.addr) = (polls.getUsersLength(), _name, msg.sender);
        polls.pushUser(MyAccount.number, _name, msg.sender);
    }

    modifier voting(string memory _title, bool _vote) {
        _;
         if(_vote == true) {
            MyAccount.voted[_title] = votingStatus.pro;
        } else {
            MyAccount.voted[_title] = votingStatus.con;
        }
    }

    // 투표 기능도 위 인스턴스 대상 컨트랙트인 poll에서 함수를 만들고 받기
    function vote(string memory _title, bool _vote) public voting(_title, _vote) {
        polls.vote(MyAccount.number, _title, _vote);
       // modifier로 상태관리
    }

    // 인스턴스 컨트랙트의 mapping에는 접근 불가!
    function suggestPoll(string calldata _title, string calldata _context) public {
        polls.suggest(_title, _context, msg.sender);
    }

}



   




// 처음 초기값 세팅 자료형별로 어떻게 해야하는지 알아보기
contract INITIALIZATION {
    uint a;
    string b;
    address c;
    bytes1 d;
    bytes e;
    bool f;

    struct set1 {
        uint a;
        string b;
        address c;
        bytes32 d;
        bytes e;
        bool f;
    }

    set1 public S1;
    set1[] group1;

    uint[] g;
    string[] h;
    bytes1[4] i;
    uint[4] j;
    address[4] k;
    string[4] l;

    struct set2 {
        uint[] g;
        string[] h;
        bytes1[4] i;
        /*uint[4] j;
        address[4] k;
        string[4] l;*/
    }

    set2 s2;

    set2[] group2;

    // 초기 세팅 방법
    function pushG1() public {
        group1.push(set1(0,"",address(0),bytes32(0),new bytes(0),false));
    }

    function pushG2() public {
        bytes1[4] memory _i;
        group2.push(set2(new uint[](0),new string[](0), _i));
    }

    function getG2() public  view returns(set2[] memory) {
        return group2; // 0: tuple(uint256[],string[],bytes1[4])[]:
    }

    function getS2() public view returns(set2 memory) {
        return s2;
    }

    function getA() public view returns(uint,string memory, address, bytes1, bytes memory, bool) {
        return (a,b,c,d,e,f);
    }

    function getG() public view returns(uint[] memory, string[] memory, bytes1[4] memory, uint[4] memory, address[4] memory, string[4] memory) {
        return (g,h,i,j,k,l );
    }
}


// 이중매핑
contract doubleMapping {
    struct user {
        uint number;
        string name;
    }

    uint[] A;
    user B;

    mapping(address => uint) balance;
    // address => string => uint
    mapping(address => mapping(string => uint)) bankAccounts;

    // user는 레퍼런스 타입이라서 key값으로 활용할 수 없다
    // mapping(user => mapping(string => uint)) bankAccounts2;
    mapping(address => mapping(string => user)) bankAccounts2;
    mapping(string=>mapping(string=>mapping(uint=>user))) bankAccounts3;

    mapping(address => uint[]) As;
    // array역시 key로 활용 불가 -> 쉽게 생각하면 복잡한 아이들은 key값으로 활용안됨
    // mapping(uint[] => address) As2;


    function setBalance() public {
        balance[msg.sender] = (msg.sender).balance;
    }

    // 이중매핑
    function setBankAccounts(string calldata _name) public {            // name은 변하지않는 값이므로 calldata(원본)
        bankAccounts[msg.sender][_name] = 100;
    }

    function getBankAccounts(address _addr, string memory _name) public view returns(uint) {
        bankAccounts[_addr][_name];
    }

    // 삼중 매핑
    function setBankAccounts(string calldata _city, string calldata _state, uint number) public {
        bankAccounts3[_city][_state][number] = B;
    }

    

}


contract TIME {
    // 유닉스 타임 출력
    uint public currentTime = block.timestamp;

    // 글로벌 베리어블(변수)을 보고 오기때문에 view
    // 위 currentTime와 다르게 시간이 계속 변한다
    function currentTime2() public view returns(uint) {
        return block.timestamp;
    }

    function currentBlockNumber() public view returns(uint) {
        return block.number;
    }
}