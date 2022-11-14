// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.3.2 (token/ERC721/ERC721.sol)

pragma solidity ^0.8.10;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "unable to send");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "insufficient balance");
        require(isContract(target), "non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
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
        _transferOwnership(_msgSender());
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
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "owner");

        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), "not approved");

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "not approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "not approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "non ERC721Receiver");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "non ERC721Receiver");
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "zero address");
        require(!_exists(tokenId), "already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "not own");
        require(to != address(0), "zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits a {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}

contract RandomNumberGenerator {
    uint256 constant minAddressesForRandomSequence = 5;
    uint256 constant sequenceLength = 70;
    uint256 constant minCountForRandomNumber = 5;

    function getRandomSequence(uint256 randomSeed, address[] memory addresses) private pure returns (uint256[] memory) {
        uint256 length = addresses.length;
        require(length >= minAddressesForRandomSequence, "Cannot get random sequence");

        uint256[] memory randomSequence = new uint256[](sequenceLength);
        uint256 base = addressToUint(addresses[randomSeed % length]);
        for (uint256 i = 1; i <= sequenceLength; i++) {
            randomSequence[i - 1] = ((base % (10**i)) - (base % (10**(i - 1)))) / 10**(i - 1);
        }
        return randomSequence;
    }

    function _randomNumber(uint256 randomSeed, address[] memory addresses) private pure returns (uint256) {
        uint256[] memory sequence = getRandomSequence(randomSeed, addresses);
        uint256 rand = 1;
        for (uint256 i = 0; i < sequenceLength / 2; i++) {
            rand += sequence[i]**sequence[sequenceLength - (i + 1)];
        }
        return rand;
    }

    function randomNumber(
        uint256 randomSeed,
        address[] memory addresses,
        uint256 max
    ) external pure returns (uint256) {
        return _randomNumber(randomSeed, addresses) % max;
    }

    function addressToUint(address _address) private pure returns (uint256) {
        return uint256(bytes32(abi.encodePacked(_address)));
    }
}

library StringHash {
    function hashStr(string memory str) internal pure returns (bytes32) {
        return bytes32(keccak256(bytes(str)));
    }

    function dualHash(string memory strA, string memory strB) internal pure returns (bytes32) {
        return keccak256(bytes(abi.encodePacked(strA, strB)));
    }
}

library StringUtils {
    function matchStrings(string memory a, string memory b) internal pure returns (bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}

abstract contract SeriesFactory is Ownable {
    struct Series {
        bool initialized;
        bool mintingIsOpen;
        string name;
    }

    mapping(bytes32 => Series) private seriesMapping;

    modifier seriesInitialized(string memory seriesName) {
        Series storage series = seriesMapping[StringHash.hashStr(seriesName)];
        require(series.initialized);

        _;
    }

    modifier seriesMintIsOpen(string memory seriesName) {
        Series storage series = seriesMapping[StringHash.hashStr(seriesName)];
        require(series.initialized && series.mintingIsOpen);
        _;
    }

    /**
     * @dev Allows owner to initialize a new series. Can only be done once per series.
     */
    function initializeSeries(string memory seriesName) public onlyOwner {
        bytes32 seriesKey = StringHash.hashStr(seriesName);
        Series storage series = seriesMapping[seriesKey];
        require(!series.initialized);

        series.initialized = true;
    }

    /**
     * @dev Allows owner to set the minting open flag for an initialized series.
     * Required step for users to be able to mint in the given series.
     */
    function setSeriesMintingIsOpen(string memory seriesName, bool mintingIsOpen)
        public
        onlyOwner
        seriesInitialized(seriesName)
    {
        Series storage series = seriesMapping[StringHash.hashStr(seriesName)];

        series.mintingIsOpen = mintingIsOpen;
    }

    /**
     * @dev Checks whether the given series was already initialized
     * and if the minting is currently open.
     */
    function getSeriesFlags(string memory seriesName) public view returns (bool initialized, bool mintingIsOpen) {
        Series storage series = seriesMapping[StringHash.hashStr(seriesName)];

        initialized = series.initialized;
        mintingIsOpen = series.mintingIsOpen;
    }
}

abstract contract RecordingUserAddresses {
    mapping(address => bool) private userInitialized;
    // array of user addresses used as seed for creating random numbers
    address[] internal users;

    function recordAddressIfNotRecorded(address user) internal {
        if (userInitialized[user]) return;

        users.push(user);
        userInitialized[user] = true;
    }
}

abstract contract WhitelistingUsersToMint is RecordingUserAddresses, Ownable {
    mapping(address => mapping(bytes32 => uint256)) private userMintsPerSeries;

    /**
     * @dev Allows owner to set individual user available mints for series.
     * Also records the address of the given user in the list, which is later used
     * as a seed for creating a random number.
     */
    function setUserMints(
        address user,
        string memory series,
        uint256 mintsPerSeries
    ) public onlyOwner {
        require(user != address(0));

        recordAddressIfNotRecorded(user);
        userMintsPerSeries[user][StringHash.hashStr(series)] = mintsPerSeries;
    }

    /**
     * @dev Returns max available mints per user for series.
     */
    function getUserMintsForSeries(address user, string memory series) public view returns (uint256) {
        return userMintsPerSeries[user][StringHash.hashStr(series)];
    }
}

abstract contract RarityToken is Ownable {
    uint256 constant MAX_MINTS_PER_LEVEL = 50;

    struct RarityLevel {
        bool initialized;
        string name;
    }

    mapping(bytes32 => mapping(uint256 => RarityLevel)) private rarityLevelMapping;

    modifier validMintsPerSeries(uint256 mintsPerSeries) {
        require(mintsPerSeries > 0 && mintsPerSeries <= MAX_MINTS_PER_LEVEL);

        _;
    }

    /**
     * @dev Allows owner to create a new rarity level. Must include rarity level name
     * and tokens available per series in the given level.
     */
    function addNewRarityLevel(
        string memory seriesName,
        string memory levelName,
        uint256 mintsPerSeries
    ) public onlyOwner validMintsPerSeries(mintsPerSeries) {
        rarityLevelMapping[StringHash.hashStr(seriesName)][mintsPerSeries] = RarityLevel(true, levelName);
    }

    /**
     * @dev Returns the num of available mints for rarity level.
     * Method will revert if the level is not found.
     */
    function getRarityLevelMintsPerSeries(string memory seriesName, string memory levelName)
        public
        view
        returns (uint256)
    {
        for (uint256 i = 1; i <= MAX_MINTS_PER_LEVEL; i++) {
            RarityLevel storage level = rarityLevelMapping[StringHash.hashStr(seriesName)][i];

            if (StringUtils.matchStrings(level.name, levelName)) return i;
        }

        require(false);
        return 1;
    }

    /**
     * @dev Returns the name of the level with the given mints per series.
     * Method will revert if the level has not been initialized with the
     * given mints per series.
     */
    function getRarityLevelName(string memory seriesName, uint256 mintsPerSeries)
        public
        view
        validMintsPerSeries(mintsPerSeries)
        returns (string memory)
    {
        RarityLevel storage level = rarityLevelMapping[StringHash.hashStr(seriesName)][mintsPerSeries];
        require(level.initialized);

        return level.name;
    }

    /**
     * @dev Returns available mints per series for each initialized rarity level.
     */
    function getRarityLevels(string memory seriesName) public view returns (uint256[] memory) {
        uint256 totalLevels = 0;
        bytes32 seriesHash = StringHash.hashStr(seriesName);

        for (uint256 i = 0; i < MAX_MINTS_PER_LEVEL; i++) {
            RarityLevel storage level = rarityLevelMapping[seriesHash][i];
            if (level.initialized) totalLevels++;
        }

        uint256[] memory rarityLevels = new uint256[](totalLevels);
        uint256 arrayIndex = 0;
        for (uint256 i = 0; i < MAX_MINTS_PER_LEVEL; i++) {
            RarityLevel storage level = rarityLevelMapping[seriesHash][i];
            if (!level.initialized) continue;

            rarityLevels[arrayIndex] = i;
            arrayIndex++;
        }

        return rarityLevels;
    }

    /**
     * @dev Allows owner to remove any rarity level
     */
    function removeRarityLevel(string memory seriesName, uint256 mintsPerSeries)
        public
        onlyOwner
        validMintsPerSeries(mintsPerSeries)
    {
        rarityLevelMapping[StringHash.hashStr(seriesName)][mintsPerSeries] = RarityLevel(false, "");
    }
}

abstract contract AutoIncrementingTokenId {
    uint256 private tokenId = 0;

    /**
     * @dev Returns an incremented token ID each time the method is called
     */
    function newTokenId() internal returns (uint256) {
        tokenId++;
        return tokenId;
    }
}

abstract contract LimitingUserMintsPerSeries is WhitelistingUsersToMint {
    mapping(address => mapping(bytes32 => uint256)) private userMintedPerSeries;

    modifier userCanMint(address user, string memory seriesName) {
        uint256 minted = userMintedInSeries(user, seriesName);
        uint256 availableMints = getUserMintsForSeries(user, seriesName);
        require(minted < availableMints);

        _;
    }

    function recordUserMint(address user, string memory seriesName) internal {
        userMintedPerSeries[user][StringHash.hashStr(seriesName)]++;
    }

    /**
     * @dev Checks how many times has the user minted in the given series
     */
    function userMintedInSeries(address user, string memory seriesName) public view returns (uint256) {
        return userMintedPerSeries[user][StringHash.hashStr(seriesName)];
    }
}

abstract contract UserMintableTokenInSeries is LimitingUserMintsPerSeries, SeriesFactory {
    struct MintableToken {
        string name;
        string sport;
        string tokenUri;
        uint256 totalAvailableMints;
        uint256 mintedInSeries;
        string series;
    }

    mapping(bytes32 => MintableToken) internal mintableTokens;
    mapping(bytes32 => bytes32[]) private mintableTokensPerSeries;

    modifier tokenInitialized(string memory name, string memory series) {
        require(isTokenInitialized(name, series));

        _;
    }

    /**
     * @dev Checks wether the given token referenced by name and series has been initialized
     */
    function isTokenInitialized(string memory name, string memory series) public view returns (bool) {
        bytes32 tokenHash = StringHash.dualHash(series, name);
        return mintableTokens[tokenHash].totalAvailableMints != 0;
    }

    function addNewMintableToken(
        string memory name,
        string memory sport,
        string memory tokenUri,
        uint256 totalAvailableMints,
        string memory series
    ) internal seriesInitialized(series) {
        require(totalAvailableMints > 0);

        bytes32 tokenHash = StringHash.dualHash(series, name);
        bytes32 seriesHash = StringHash.hashStr(series);

        require(!isTokenInitialized(name, series));

        mintableTokens[tokenHash] = MintableToken(name, sport, tokenUri, totalAvailableMints, 0, series);
        mintableTokensPerSeries[seriesHash].push(tokenHash);
    }

    /**
     * @dev Returns an array of token hashes for each mintable token in the given series.
     * The token hash also appears the exact number of times in the array for each
     * available mint
     */
    function getMintableTokenHashesArray(string memory series) internal view returns (bytes32[] memory) {
        uint256 totalMintableTokens = 0;
        bytes32[] storage tokenHashes = mintableTokensPerSeries[StringHash.hashStr(series)];
        MintableToken[] memory tokens = new MintableToken[](tokenHashes.length);

        for (uint256 i = 0; i < tokenHashes.length; i++) {
            tokens[i] = mintableTokens[tokenHashes[i]];
        }

        for (uint256 i = 0; i < tokens.length; i++) {
            uint256 mintedInSeries = tokens[i].mintedInSeries;
            uint256 totalAvailableMints = tokens[i].totalAvailableMints;

            totalMintableTokens += totalAvailableMints - mintedInSeries;
        }

        bytes32[] memory mintableTokenHashesArray = new bytes32[](totalMintableTokens);
        uint256 arrayIndex = 0;

        for (uint256 i = 0; i < tokens.length; i++) {
            MintableToken memory token = tokens[i];
            uint256 availableMints = token.totalAvailableMints - token.mintedInSeries;
            bytes32 tokenHash = StringHash.dualHash(token.series, token.name);

            for (uint256 j = 0; j < availableMints; j++) {
                mintableTokenHashesArray[arrayIndex] = tokenHash;
                arrayIndex++;
            }
        }

        return mintableTokenHashesArray;
    }

    /**
     * @dev Returns how many times has the given token been minted in the series
     * and how many times the token can be minted
     */
    function getTokenMintData(string memory name, string memory series)
        public
        view
        tokenInitialized(name, series)
        returns (uint256 totalAvailableMints, uint256 mintedInSeries)
    {
        MintableToken storage token = mintableTokens[StringHash.dualHash(series, name)];

        totalAvailableMints = token.totalAvailableMints;
        mintedInSeries = token.mintedInSeries;
    }

    function recordTokenMint(string memory name, string memory series) internal tokenInitialized(name, series) {
        MintableToken storage token = mintableTokens[StringHash.dualHash(series, name)];

        require(token.mintedInSeries < token.totalAvailableMints);

        token.mintedInSeries++;
    }
}

struct MintedToken {
    uint256 tokenId;
    string name;
    string sport;
    string tokenUri;
    string rarityLevel;
    uint256 totalAvailable;
    string series;
}

abstract contract RecordingMintedTokens {
    struct UserTokens {
        uint256 amountOfTokens;
        uint256[] tokenIds;
    }

    mapping(uint256 => MintedToken) private mintedTokenData;
    mapping(address => UserTokens) private userOwnedTokens;
    mapping(bytes32 => uint256[]) private nameAndSportToTokenIds;

    function addMintedToken(MintedToken memory token) internal {
        require(token.tokenId != 0);
        require(mintedTokenData[token.tokenId].tokenId == 0);

        bytes32 tokenHash = StringHash.dualHash(token.name, token.sport);
        mintedTokenData[token.tokenId] = token;
        nameAndSportToTokenIds[tokenHash].push(token.tokenId);
    }

    /**
     * @dev Returns all token data for the given token ID
     */
    function getTokenData(uint256 tokenId) public view returns (MintedToken memory) {
        return mintedTokenData[tokenId];
    }

    function getAllTokensByNameAndSport(string memory name, string memory sport)
        public
        view
        returns (MintedToken[] memory)
    {
        bytes32 tokenHash = StringHash.dualHash(name, sport);
        uint256 tokensCount = nameAndSportToTokenIds[tokenHash].length;
        MintedToken[] memory tokens = new MintedToken[](tokensCount);

        for (uint256 i = 0; i < tokensCount; i++) {
            tokens[i] = mintedTokenData[nameAndSportToTokenIds[tokenHash][i]];
        }

        return tokens;
    }

    /**
     * @dev Returns an array with all data for tokens belonging to the user
     */
    function getAllUserTokens(address user) public view returns (MintedToken[] memory) {
        uint256 tokensCount = userOwnedTokens[user].amountOfTokens;
        MintedToken[] memory tokens = new MintedToken[](tokensCount);
        uint256[] memory tokenIds = userOwnedTokens[user].tokenIds;
        uint256 tokenIndex = 0;

        for (uint256 i = 0; i < tokenIds.length; i++) {
            if (tokenIds[i] == 0) continue;

            tokens[tokenIndex] = mintedTokenData[tokenIds[i]];
            tokenIndex++;
        }

        return tokens;
    }

    function removeTokenId(UserTokens storage userTokens, uint256 tokenId) private {
        bool deleted = false;

        for (uint256 i = 0; i < userTokens.tokenIds.length; i++) {
            if (userTokens.tokenIds[i] != tokenId) continue;

            userTokens.tokenIds[i] = 0;
            deleted = true;
        }

        if (deleted) {
            userTokens.amountOfTokens--;
        }
    }

    function addTokenId(UserTokens storage userTokens, uint256 tokenId) private {
        userTokens.tokenIds.push(tokenId);
        userTokens.amountOfTokens++;
    }

    /**
     * @dev Triggered on initial token mint and when token is transferred to
     * another user.
     */
    function transferTokenOwnership(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        removeTokenId(userOwnedTokens[from], tokenId);
        addTokenId(userOwnedTokens[to], tokenId);
    }
}

/***********************************************************************
 ***********************************************************************
 **********************      MINO TOKEN        *************************
 ***********************************************************************
 **********************************************************************/

contract MinoToken is ERC721, RarityToken, UserMintableTokenInSeries, RecordingMintedTokens, AutoIncrementingTokenId {
    RandomNumberGenerator rngContract;

    string private baseURI;

    constructor(
        string memory name_,
        string memory symbol_,
        string memory baseURI_,
        RandomNumberGenerator rngContract_
    ) ERC721(name_, symbol_) Ownable() {
        baseURI = baseURI_;
        rngContract = rngContract_;
    }

    /**
     * @dev Allows owner to create a new mintable token for a series.
     * Must provide a unique name within the given series and must provide
     * a valid rarity level name. The series must be already initialized before
     * adding mintable tokens.
     */
    function addNewMintableToken(
        string memory name,
        string memory sport,
        string memory tokenUri,
        string memory rarityLevel,
        string memory series
    ) public onlyOwner seriesInitialized(series) {
        addNewMintableToken(name, sport, tokenUri, getRarityLevelMintsPerSeries(series, rarityLevel), series);
    }

    /**
     * @dev Allows any whitelisted user who can still mint in the given series to mint a new
     * token if there are any available mintable tokens in the series.
     * Users which can still mint in the given series will receive a random token
     * from the list of available tokens in the series.
     */
    function mintToken(string memory series) public seriesMintIsOpen(series) userCanMint(_msgSender(), series) {
        bytes32[] memory mintableTokenHashes = getMintableTokenHashesArray(series);
        require(mintableTokenHashes.length != 0);

        uint256 tokenId = newTokenId();
        uint256 randomNumber = rngContract.randomNumber(
            block.difficulty * block.timestamp,
            users,
            mintableTokenHashes.length
        );
        bytes32 tokenHash = mintableTokenHashes[randomNumber];

        MintableToken storage mintableToken = mintableTokens[tokenHash];
        MintedToken memory newToken = MintedToken(
            tokenId,
            mintableToken.name,
            mintableToken.sport,
            mintableToken.tokenUri,
            getRarityLevelName(series, mintableToken.totalAvailableMints),
            mintableToken.totalAvailableMints,
            series
        );

        addMintedToken(newToken);
        recordTokenMint(mintableToken.name, series);
        recordUserMint(_msgSender(), series);
        _mint(_msgSender(), tokenId);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        transferTokenOwnership(from, to, tokenId);
    }
}
