// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "./DBToken.sol";
// import "./Context.sol";
// import "./StandardToken.sol";
// import "./SaleFactory.sol";


/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

interface StandardToken {


    function transferFrom(address _from, address _to, uint _value) external;

    function transfer(address _to, uint256 _value) external;

    function approve(address _spender, uint _value) external;

    function allowance(address _owner, address _spender) external view returns (uint256);

    function balanceOf(address _owner) external returns (uint256);
}


/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract TradingPair {
    address private _factory;

    address[2] private tokens;

    bytes4 private constant SELECTOR = bytes4(keccak256("transferFrom(address,address,uint256)"));


    constructor(address token1, address token2) {
        _factory = msg.sender;
        tokens[0] = token1;
        tokens[1] = token2;
    }

    // Retreives individual addresses of both tokens
    function getPairAddresses() external view returns (address token1, address token2) {
        return (tokens[0], tokens[1]);
    }

    // Retreives names of tokens in format token1Name/token2Name
    function getPairNames() external view returns (string memory) {
        string memory token1Name = IERC20Metadata(getToken(0)).name();
        string memory token2Name = IERC20Metadata(getToken(1)).name();
        return string(abi.encodePacked(token1Name, "/", token2Name));
    }

    // Retreives symbols of tokens in format token1Symbol/token2Symbol
    function getPairSymbols() external view returns (string memory) {
        string memory token1Symbol = IERC20Metadata(getToken(0)).symbol();
        string memory token2Symbol = IERC20Metadata(getToken(1)).symbol();
        return string(abi.encodePacked(token1Symbol, "/", token2Symbol));
    }

    // Call transferFrom function on token with selector. Function reverts if call is unsuccessful
    function _transferFrom(address token, address from, address to, uint256 value) private returns (bool) {        
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TradingPair: TRANSFER_FAILED');
        return true;
    }

    // Get individual token address. Index is in [0, 1]
    function getToken(uint8 index) public view returns (address) {
        require(index == 0 || index == 1, "TradingPair: invalid index");
        return tokens[index];
    }

    

    // Swap! Called from TradingFactory. swapFrom is msg.sender in factory
    function swap(uint256 amountOut, uint256 amountIn, address swapFrom, address swapTo, uint8 fromIndex, uint8 toIndex) external returns (bool) {
        require(fromIndex != toIndex, "TradingPair: from and to index cannot be same");

        address tokenFrom = getToken(fromIndex);
        address tokenTo = getToken(toIndex);

        uint256 allowanceFrom = IERC20(tokenFrom).allowance(swapFrom, address(this));
        uint256 allowanceTo = IERC20(tokenTo).allowance(swapTo, address(this));

        require(amountOut <= allowanceFrom, "TradingPair: Insufficient outgoing allowance");
        require(amountIn <= allowanceTo, "TradingPair: Insufficient incoming allowance");


        _transferFrom(tokenFrom, swapFrom, swapTo, amountOut); // Token sent for swapping
        _transferFrom(tokenTo, swapTo, swapFrom, amountIn); // Token received from swap
        return true;
    }
}


contract DBToken is IERC20, IERC20Metadata, Ownable {

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    string private _eventCode;
    string private _teamName;

    /**
     * @dev Next to the regular name and symbol params, constructor takes an event code and team name
     * @param name_ Name of the token. Generally "DBToken"
     * @param symbol_ Symbol of the token. Generally "DBT"
     * @param eventCode_ Event code of the token. Later could be used in the DBTokenSale contract to end the tokens under given event
     * @param teamName_ Name of the team the token is representing
     * @param totalSupply_ Initialy total supply of the tokens
     */
    constructor(
        string memory name_,
        string memory symbol_,
        string memory eventCode_,
        string memory teamName_,
        uint256 totalSupply_
    ) Ownable() {
        _name = name_;
        _symbol = symbol_;
        _eventCode = eventCode_;
        _teamName = teamName_;
        _totalSupply = totalSupply_;
        _balances[owner()] = totalSupply_;
    }

    function name() external view override returns (string memory) {
        return _name;
    }

    function symbol() external view override returns (string memory) {
        return _symbol;
    }

    function eventCode() external view returns (string memory) {
        return _eventCode;
    }

    function teamName() external view returns (string memory) {
        return _teamName;
    }

    function decimals() external pure override returns (uint8) {
        return 18;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        external
        view
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        require(
            _allowances[sender][_msgSender()] >= amount,
            "DBToken: transfer amount exceeds allowance"
        );
        _transfer(sender, recipient, amount);

        unchecked {
            _approve(
                sender,
                _msgSender(),
                _allowances[sender][_msgSender()] - amount
            );
        }

        return true;
    }

    function _mint(address account, uint256 amount)
        external
        onlyOwner
        returns (bool)
    {
        require(account != address(0), "DBToken: mint to the zero address");

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        require(
            sender != address(0),
            "DBToken: transfer from the zero address"
        );
        require(
            recipient != address(0),
            "DBToken: transfer to the zero address"
        );

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "DBToken: transfer amount exceeds balance"
        );

        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) private {
        require(owner != address(0), "DBToken: approve from the zero address");
        require(spender != address(0), "DBToken: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    fallback(bytes calldata _input) external returns (bytes memory _output) {
        return bytes('notfound');
    }
}


contract TradingFactory is Context {

    TradingPair[] private _tradingPairs;
    mapping(address => mapping(address => TPRef)) private _tradingPairRefs;

    struct TPRef {
        bool status;
        uint256 index;
    }

    struct TPAddresses {
        address token1;
        address token2;
    }

    
    /**
     * @dev Function to add a new trading pair. Function will revert if the pair already exists. 
     * Pair token1/token2 is considered the same as token2/token1
     * @param token1 address of the first token
     * @param token2 address of the second token
     */
    function addTradingPair(address token1, address token2) public returns (bool) {

        require(!_tradingPairRefs[token1][token2].status, "TradingFactory: pair already exists");

        uint256 index = _tradingPairs.length;
        TradingPair pair = new TradingPair(token1, token2);
        _tradingPairs.push(pair);

        TPRef memory ref = TPRef(true, index);

        // Reference added in both directions
        _tradingPairRefs[token1][token2] = ref;
        _tradingPairRefs[token2][token1] = ref;
        
        return true;
    }

    // Used internally to fetch trading pair. Will revert if pair is not found
    function getPair(address token1, address token2) private view returns (TradingPair) {
        require(_tradingPairRefs[token1][token2].status, "TradingFactory: pair not initialized");
        return _tradingPairs[_tradingPairRefs[token1][token2].index];
    }


    // Used to get individual token addresses from _tradingPairs[index]. Different from tradingPairAddress
    function getPairAddresses(uint256 index) public view returns (address token1, address token2) {
        require(index < _tradingPairs.length, "TradingFactory: invalid pair index");
        return _tradingPairs[index].getPairAddresses();
    }

    // Get names of tokens in _tradingPairs[index] in format token1Name/token2Name
    function getPairNames(uint256 index) public view returns (string memory) {
        require(index < _tradingPairs.length, "TradingFactory: invalid pair index");
        return _tradingPairs[index].getPairNames();
    }

    // Get symbols of tokens in _tradingPairs[index] in format token1Symbol/token2Symbol
    function getPairSymbols(uint256 index) public view returns (string memory) {
        require(index < _tradingPairs.length, "TradingFactory: invalid pair index");
        return _tradingPairs[index].getPairSymbols();
    }

    // Retreives a list of all token pairs with each pair represented [{ token1: address, token2: address } ...]
    function trandingPairs() public view returns (TPAddresses[] memory) {
        uint256 length = _tradingPairs.length;
        TPAddresses[] memory pairs = new TPAddresses[](length);
        for (uint i; i < length; i++) {
            (address token1, address token2) = getPairAddresses(i);
            pairs[i] = TPAddresses(token1, token2);
        }

        return pairs;
    }

    /**
     * @dev Retreive address of the pair contract. This function is mandatory for use as both users have to approve
     * the right amount of tokens towards this address before a swap is possible. Function will revert if pair is not found.
     * Will retreive the same address for combinations (token1, token2)/(token2, token1)
     * @param token1 address of first token
     * @param token2 address of second token
     */
    function tradingPairAddress(address token1, address token2) public view returns (address) {
        return address(getPair(token1, token2));
    }



    /**
     * @dev Will swap "amountOut" amount of "token1" tokens for "amountIn" amount of "token2" tokens.
     * The outgoing amount of tokens is taken from the msg.sender's account on "token1" and the incoming
     * amount of tokens is taken from swapTo's account on "token2". This function requires that
     * msg.sender has approved "amountOut" tokens and swapTo has approved "amountIn" tokens towards pair address.
     * If at least one of the allowances is insufficient, the swap will not work at all.
     * The pair address can be retreived with function tradingPairAddress(token1, token2)
     * @param token1 address of outgoing token
     * @param token2 address of incoming token
     * @param amountOut amount of token1 tokens being sent
     * @param amountIn amount of token2 tokens expected
     * @param swapTo account you are making the swap with
     */
    function swap(address token1, address token2, uint256 amountOut, uint256 amountIn, address swapTo) public returns (bool) {
        TradingPair pair = getPair(token1, token2);

        uint8 fromIndex;
        uint8 toIndex;
        

        if (pair.getToken(0) == token1) {
            fromIndex = 0;
            toIndex = 1;
        } else {
            fromIndex = 1;
            toIndex = 0;
        }


        pair.swap(amountOut, amountIn, _msgSender(), swapTo, fromIndex, toIndex);

        return true;
    }


}

contract SaleFactory is Ownable {

    // Each sale has an entry in the eventCode hash table with start and end time.
    // If both saleStart and saleEnd are 0, sale is not initialized
    struct Sale {
        uint256 saleStart;
        uint256 saleEnd;
    }
    mapping(bytes32 => Sale) private _eventSale;
    bytes32[] private _allSales;

    // Modifier allowing a call if and only if there are no active sales at the moment
    modifier noActiveSale() {
        for (uint256 i; i < _allSales.length; i++) {
            require(saleIsActive(false, _eventSale[_allSales[i]]), "SaleFactory: unavailable while a sale is active");
        }
        _;
    }

    // Modifier allowing a call only if event by eventCode is currently active
    modifier duringSale(string memory eventCode) {
        Sale storage eventSale = getEventSale(eventCode);
        require(
            saleIsActive(true, eventSale),
            "SaleFactory: function can only be called during sale"
        );
        _;
        clearExpiredSales();
    }

    // Modifier allowing a call only if event by eventCode is currently inactive
    modifier outsideOfSale(string memory eventCode) {
        // We are fetching the event directly through a hash, since getEventSale reverts if sale is not initialized
        Sale storage eventSale = _eventSale[hashStr(eventCode)];
        require(
            saleIsActive(false, eventSale),
            "SaleFactory: function can only be called outside of sale"
        );
        
        _;
    }

    /**
     * @dev Function returns true if our expectations on status of sale is correct
     * @param expectActive If we expect the sale to be active set to true
     * @param sale Sale that is being inspected
     */
    function saleIsActive(bool expectActive, Sale memory sale) private view returns (bool) {
        if (expectActive) {
            return (time() >= sale.saleStart) && (time() < sale.saleEnd);
        } else {
            return (time() < sale.saleStart) || (time() >= sale.saleEnd);
        }
    }


    // Returns all active or soon-to-be active sales in an array ordered by sale end time
    function getAllSales() public view returns (Sale[] memory) {
        uint256 length = _allSales.length;

        Sale[] memory sales = new Sale[](length);

        for (uint256 i; i < length; i++) {
            sales[i] = _eventSale[_allSales[i]];
        }
        return sales;
    }


    // Clears all sales from the _allSales array who's saleEnd time is in the past
    function clearExpiredSales() private returns (bool) {
        uint256 length = _allSales.length;
        if (length > 0 && _eventSale[_allSales[0]].saleEnd <= time()) {
            uint256 endDelete = 1;

            bytes32[] memory copyAllSales = _allSales; 

            uint256 i = 1;
            while (i < length) {
                if (_eventSale[_allSales[i]].saleEnd > time()) {
                    endDelete = i;
                    i = length; // Break from while loop
                }
                i++;
            }

            for (i = 0; i < length; i++) {
                if (i < length - endDelete) {
                    _allSales[i] = copyAllSales[i + endDelete];
                } else {
                    _allSales.pop();
                }
            }
        }
        return true;
    }

    // Return current timestamp
    function time() public view returns (uint256) {
        return block.timestamp;
    }

    function hashStr(string memory str) private pure returns (bytes32) {
        return bytes32(keccak256(bytes(str)));
    }

    /**
     * @dev Function inserts a sale reference in the _allSales array and orders it by saleEnd time
     * in ascending order. This means the first sale in the array will expire first.
     * @param saleHash hash reference to the sale mapping structure
     */
    function insertSale(bytes32 saleHash) private returns (bool) {
        uint256 length = _allSales.length;

        bytes32 unorderedSale = saleHash;
        bytes32 tmpSale;

        for (uint256 i; i <= length; i++) {
            if (i == length) {
                _allSales.push(unorderedSale);
            } else {
                if (_eventSale[_allSales[i]].saleEnd > _eventSale[unorderedSale].saleEnd) {
                    tmpSale = _allSales[i];
                    _allSales[i] = unorderedSale;
                    unorderedSale = tmpSale;
                }
            }
        }
        return true;
    }

    /**
     * @dev Function returns Sale struct with saleEnd and saleStart. Function reverts if event is not initialized
     * @param eventCode string code of event
     */
    function getEventSale(string memory eventCode) private view returns (Sale storage) {
        Sale storage eventSale = _eventSale[hashStr(eventCode)];
        require(eventSale.saleStart > 0 || eventSale.saleEnd > 0, "SaleFactory: sale not initialized");
        return eventSale;
    }

    /**
     * @dev Function to set the start and end time of the next sale.
     * Can only be called if there is currently no active sale and needs to be called by the owner of the contract.
     * @param start Unix time stamp of the start of sale. Needs to be a timestamp in the future. If the start is 0, the sale will start immediately.
     * @param end Unix time stamp of the end of sale. Needs to be a timestamp after the start
     */
    function setSaleStartEnd(string memory eventCode, uint256 start, uint256 end)
        public
        onlyOwner
        outsideOfSale(eventCode)
        returns (bool)
    {
        bool initialized;
        bytes32 saleHash = hashStr(eventCode);
        Sale storage eventSale = _eventSale[saleHash];
        if (eventSale.saleStart == 0 && eventSale.saleEnd == 0) {
            initialized = false;
        }
        

        if (start != 0) {
            require(start > time(), "SaleFactory: given past sale start time");
        } else {
            start = time();
        }
        require(
            end > start,
            "SaleFactory: sale end time needs to be greater than start time"
        );

        eventSale.saleStart = start;
        eventSale.saleEnd = end;

        if (!initialized) {
            insertSale(saleHash);
        }

        return true;
    }

    // Function can be called by the owner during a sale to end it prematurely
    function endSaleNow(string memory eventCode) public onlyOwner duringSale(eventCode) returns (bool) {
        Sale storage eventSale = getEventSale(eventCode);

        eventSale.saleEnd = time();
        return true;
    }

    /**
     * @dev Public function which provides info if there is currently any active sale and when the sale status will update.
     * There are 3 possible return patterns:
     * 1) Sale isn't active and sale start time is in the future => saleActive: false, saleUpdateTime: _saleStart
     * 2) Sale is active => saleActive: true, saleUpdateTime: _saleEnd
     * 3) Sale isn't active and _saleStart isn't a timestamp in the future => saleActive: false, saleUpdateTime: 0
     * @param eventCode string code of event
     */
    function isSaleOn(string memory eventCode)
        public
        view
        returns (bool saleActive, uint256 saleUpdateTime)
    {
        Sale storage eventSale = getEventSale(eventCode);

        if (eventSale.saleStart > time()) {
            return (false, eventSale.saleStart);
        } else if (eventSale.saleEnd > time()) {
            return (true, eventSale.saleEnd);
        } else {
            return (false, 0);
        }
    }
}

contract DBTokenSale is SaleFactory {
    address private _owner;
    address private _withrawable;

    StandardToken private _standardToken;
    mapping(bytes32 => DBToken) private _dbtokens;

    struct TokensSold {
        bytes32 tokenHash;
        uint256 amountSold;
    }
    TokensSold[] _currentSale;

    struct TokenSoldReference {
        bool status;
        uint256 arrayIndex;
    }
    mapping(bytes32 => TokenSoldReference) private _saleArrayMapping;

    /**
     * @param standardToken_ Standard token is the USDT contract from which the sale contract will allow income of funds from. The contract should extend the StandardToken interface
     * @param withrawable Address where the funds can be withdrawn to
     */
    constructor(StandardToken standardToken_, address withrawable) Ownable() {
        _standardToken = standardToken_;
        _withrawable = withrawable;
    }

    /**
     * @dev This function adds DBToken references to the _dbtokens mapping. The function expects event code and team name to be supplied.
     * This is only added for additional security to check if the owner is adding the correct address.
     * @param _token Address of the DBToken you are adding
     * @param _eventCode Event code of the DBToken reference. Has to match the event code the token has been initialized with.
     * @param _teamName Same as event code. Has to match the team name the token has been initialized with
     * @param initialAmount Amount of tokens which is initially minted to contract address
     */
    function addDBTokenReference(
        DBToken _token,
        string memory _eventCode,
        string memory _teamName,
        uint256 initialAmount
    ) public onlyOwner returns (bool) {
        bytes32 tokenEventCode = keccak256(bytes(_token.eventCode()));
        bytes32 tokenTeamName = keccak256(bytes(_token.teamName()));
        bytes32 givenEventCode = keccak256(bytes(_eventCode));
        bytes32 givenTeamName = keccak256(bytes(_teamName));

        require(
            tokenEventCode == givenEventCode,
            "DBTokenSale: given event code doesn't match reference event code"
        );
        require(
            tokenTeamName == givenTeamName,
            "DBTokenSale: given team name doesn't match reference team name"
        );

        bytes32 tokenHash = getTokenHash(_eventCode, _teamName);

        _dbtokens[tokenHash] = _token;

        _dbtokens[tokenHash]._mint(address(this), initialAmount);
        return true;
    }

    

    // function hashStr(string memory str) private pure returns (bytes32) {
    //     return bytes32(keccak256(bytes(str)));
    // }

    /**
     * Get token by event code and team name. Revert on not found
     */
    function getToken(string memory _eventCode, string memory _teamName)
        public
        view
        returns (DBToken)
    {
        bytes32 tokenHash = getTokenHash(_eventCode, _teamName);
        require(
            address(_dbtokens[tokenHash]) != address(0),
            "DBTokenSale: token doesn't exist"
        );
        return _dbtokens[tokenHash];
    }

    /**
     * @dev Public function from which users can buy token from. A requirement for this purchase is that the user has approved
     * at least the given amount of standardToken funds for transfer to contract address. The user has to input the event code
     * and the team name of the token they are looking to purchase and the amount of tokens they are looking to purchase.
     * @param _eventCode Event code of the DBToken
     * @param _teamName Team name of the DBToken
     * @param amount Amount of tokens the user wants to purchase. Has to have pre-approved amount of USDT tokens for transfer.
     */
    function buyTokens(
        string memory _eventCode,
        string memory _teamName,
        uint256 amount
    ) public duringSale(_eventCode) returns (bool) {
        DBToken dbtoken = getToken(_eventCode, _teamName);

        require(
            dbtoken.balanceOf(address(this)) >= amount,
            "DBTokenSale: insufficient tokens in contract account"
        );

        uint256 senderAllowance = _standardToken.allowance(
            _msgSender(),
            address(this)
        );
        require(
            senderAllowance >= amount,
            "DBTokenSale: insufficient allowance for standard token transaction"
        );

        uint256 dbtokenAmount = amount * rate();
        _standardToken.transferFrom(_msgSender(), address(this), amount);
        dbtoken.transfer(_msgSender(), dbtokenAmount);

        bytes32 tokenHash = getTokenHash(_eventCode, _teamName);
        recordTokensSold(tokenHash, dbtokenAmount);

        return true;
    }

    function initTokensSold(bytes32 tokenHash, uint256 initialAmount)
        private
        returns (bool)
    {
        require(
            !_saleArrayMapping[tokenHash].status,
            "DBTokenSale: TokenSold reference already initialized"
        );

        uint256 arrayIndex = _currentSale.length;

        _currentSale.push(TokensSold(tokenHash, initialAmount));
        _saleArrayMapping[tokenHash] = TokenSoldReference(true, arrayIndex);

        return true;
    }

    function increaseTokensSold(bytes32 tokenHash, uint256 amount)
        private
        returns (bool)
    {
        require(
            _saleArrayMapping[tokenHash].status,
            "DBTokenSale: TokenSold reference is not initialized"
        );

        _currentSale[_saleArrayMapping[tokenHash].arrayIndex]
            .amountSold += amount;

        return true;
    }

    function recordTokensSold(bytes32 tokenHash, uint256 amount)
        private
        returns (bool)
    {
        if (!_saleArrayMapping[tokenHash].status) {
            initTokensSold(tokenHash, amount);
        } else {
            increaseTokensSold(tokenHash, amount);
        }

        return true;
    }

    function mintOnePercentToOwner()
        public
        onlyOwner
        noActiveSale
        returns (bool)
    {
        bytes32 tokenHash;
        uint256 amountToMint;

        for (uint256 i; i < _currentSale.length; i++) {
            tokenHash = _currentSale[i].tokenHash;
            amountToMint = _currentSale[i].amountSold / 100;

            _dbtokens[tokenHash]._mint(owner(), amountToMint);

        }

        delete _currentSale;
        return true;
    }

    function tokensSold() public view onlyOwner returns (TokensSold[] memory) {
        return _currentSale;
    }

    function balanceOf(
        string memory _eventCode,
        string memory _teamName,
        address _account
    ) public view returns (uint256) {
        DBToken dbtoken = getToken(_eventCode, _teamName);
        return dbtoken.balanceOf(_account);
    }

    /**
     * @dev Allows the owner of the contract to withdraw the funds from to contract to the address in the variable withdrawable
     * @param amount Amount of tokens standardTokens the owner wants to withdraw. If the amount is more than the current balance, all tokens are withdrawn.
     */
    function withdraw(uint256 amount) public onlyOwner returns (bool) {
        require(
            _withrawable != address(0),
            "DBTokenSale: withdrawable address is zero address"
        );
        uint256 tokenBalance = _standardToken.balanceOf(address(this));
        if (amount > tokenBalance) {
            amount = tokenBalance;
        }

        _standardToken.transfer(_withrawable, amount);
        return true;
    }

    function getTokenHash(string memory _eventCode, string memory _teamName)
        private
        pure
        returns (bytes32)
    {
        return keccak256(bytes(abi.encodePacked(_eventCode, _teamName)));
    }

    // Rate represents how many DBTokens can be purchased with 1 USDT
    function rate() public pure returns (uint256) {
        return 1;
    }
}
