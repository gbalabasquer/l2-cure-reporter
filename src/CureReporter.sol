// SPDX-License-Identifier: AGPL-3.0-or-later

/// CureReporter.sol -- CureReporter

// Copyright (C) 2022 Dai Foundation
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.8.12;

interface VatLike {
    function debt() external view returns (uint256);
    function live() external view returns (uint256);
    function Line() external view returns (uint256);
}

interface WormholeJoinLike {
    function cure() external view returns (uint256);
}

contract CureReporter {
    VatLike          public immutable vat;
    WormholeJoinLike public immutable wJoin;

    constructor(address vat_, address wJoin_) {
        vat = VatLike(vat_);
        wJoin = WormholeJoinLike(wJoin_);
    }

    function cure() external view returns (uint256 cure_) {
        require(vat.live() == 0, "CureReporter/vat-still-live");
        cure_ = vat.Line() - vat.debt() + wJoin.cure();
    }
}
