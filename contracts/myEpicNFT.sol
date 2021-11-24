pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // This is our SVG code

    string bgColorSvg =
        "<svg viewBox='0 0 353.32 282.413' style='background-color: ";
    string triangleColorSvg =
        ";' xmlns='http://www.w3.org/2000/svg' xmlns:bx='https://boxy-svg.com'><defs><radialGradient gradientUnits='userSpaceOnUse' cx='134.815' cy='104.521' r='15.441' id='gradient-1'><stop offset='0' style='stop-color: rgba(187, 218, 85, 1)'/><stop offset='1' style='stop-color: rgba(135, 165, 36, 1)'/></radialGradient><radialGradient gradientUnits='userSpaceOnUse' cx='182.729' cy='89.51' r='21.24' id='gradient-0'><stop offset='0' style='stop-color: #bada55'/><stop offset='1' style='stop-color: #758d29'/></radialGradient></defs><path d='M 136.989 33.527 L 251.099 231.171 L 22.879 231.171 L 136.989 33.527 Z' style='fill: ";
    string eyeColor1Svg =
        ";' transform='matrix(0.999949, -0.010097, 0.010097, 0.999949, 27.039745, 3.240297)' bx:shape='triangle 22.879 33.527 228.22 197.644 0.5 0 1@f6db421a'/><circle style='filter: none; stroke: url(#gradient-1); fill: rgb(255, 255, 255); paint-order: fill;' cx='134.815' cy='104.521' r='15.441'/><circle style='paint-order: stroke markers; fill: rgb(255, 255, 255); stroke: url(#gradient-0);' cx='182.729' cy='89.51' r='21.24'/><circle style='fill: ";
    string eyeColor2Svg =
        ";' cx='182.844' cy='89.308' r='9.529'/><circle style='fill: ";
    string mouthSvg =
        ";' cx='129.102' cy='99.214' r='6.139' transform='matrix(1.284064, 0, 0, 1.438087, -32.371578, -39.947289)'/><path style='fill: rgb(40, 28, 28); fill-rule: nonzero;' transform='matrix(0.3714, 1.214975, -1.217874, 0.372286, 401.186066, -246.856903)' d='M 238.392 242.178 A 31.198 31.198 0 0 1 238.392 303.806 A ";
    string restSvg =
        " 38.72 0 0 0 238.392 242.178 Z' bx:shape='crescent 233.512 272.992 31.198 162 0.823 1@68105cc8'/></svg>";


    string[] bgColor = [
        "aliceblue",
        "antiquewhite",
        "beige",
        "azure",
        "cadetblue",
        "mintcream",
        "mistyrose",
        "moccasin"
    ];
    string[] triangleColor = [
        "darksalmon",
        "steelblue",
        "sandybrown",
        "seagreen",
        "violet",
        "springgreen",
        "midnightblue",
        "orangered",
        "hotpink",
        "gold",
        "darkslateblue",
        "yellowgreen"
    ];
    string[] eyeColor = [
        "black",
        "deepskyblue",
        "saddlebrown",
        "slategray",
        "darkred",
        "indigo"
    ];
    string[] mouth = [
        "0",
        "5",
        "10",
        "15",
        "20",
        "25",
        "30",
        "35",
        "40",
        "45",
        "50",
        "55",
        "60",
        "115"
    ];

    constructor() ERC721("triangulinNFT", "TRLIN") {
        console.log("This is my NFT contract. Woah!");
    }

    function pickRandomBGColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("BG_COLOR", Strings.toString(tokenId)))
        );
        rand = rand % bgColor.length;
        return string(abi.encodePacked(bgColorSvg, bgColor[rand]));
    }

    function pickRandomTriangleColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(
                abi.encodePacked("TRIANGLE_COLOR", Strings.toString(tokenId))
            )
        );
        rand = rand % triangleColor.length;
        return string(abi.encodePacked(triangleColorSvg, triangleColor[rand]));
    }

    function pickRandomEyeColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("EYE_COLOR", Strings.toString(tokenId)))
        );
        rand = rand % eyeColor.length;
        return
            string(
                abi.encodePacked(
                    eyeColor1Svg,
                    eyeColor[rand],
                    eyeColor2Svg,
                    eyeColor[rand]
                )
            );
    }

    function pickRandomMouth(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("MOUTH", Strings.toString(tokenId)))
        );
        rand = rand % mouth.length;
        return string(abi.encodePacked(mouthSvg, mouth[rand], restSvg));
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // A function our user will hit to get their NFT.
    function makeAnEpicNFT() public {
        // Get the current tokenId, this starts at 0.
        uint256 newItemId = _tokenIds.current();

        require(newItemId < 50, 'No more items available in this collection');

        string memory choosenBgColor = pickRandomBGColor(newItemId);
        string memory choosenTriangleColor = pickRandomTriangleColor(newItemId);
        string memory choosenEyeColor = pickRandomEyeColor(newItemId);
        string memory choosenMouth = pickRandomMouth(newItemId);

        string memory finalSvg = string(
            abi.encodePacked(
                choosenBgColor,
                choosenTriangleColor,
                choosenEyeColor,
                choosenMouth
            )
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        "Triangulin #", Strings.toString(newItemId),
                        '", "description": "A highly acclaimed collection of triangulines.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();

        console.log(
            "An NFT triangulin w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
