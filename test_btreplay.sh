#!/bin/bash

# Test 1: check that the write below was replayed correctly (from mail.replay.0):
# The homes traces have a digest per 8 sectors, or 32 bytes per 1 page (the -l 32 in the args)
#
# 89967404311353 4253 nfsd 680 16 W 6 0 b5e9f4e5ab62a4fff5313a606b0ad4e3e6434714a2358bc5f55005d6c5502d80
test_write_digest_per_page() {
	rm -f mail
	truncate -s $((1000 * 512)) mail
	./btreplay/btreplay -l 32 -W mail
	s1=`cut -b $((680 * 512))-$((688 * 512)) mail`
	s2=`cut -b $((688 * 512))-$((696 * 512)) mail`
	if [ "b5e9f4e5ab62a4fff5313a606b0ad4e3" == "$s1" ] && \
		[ "e6434714a2358bc5f55005d6c5502d80" == "$s2" ]; then
		echo ok
	else
		echo "fail: $s1"
		exit 1
	fi
}

# Test 2: check that the write below was replayed correctly (from mail.replay.0):
# The homes traces have a digest per 8 sectors, or 32 bytes per 1 page (the -l 32 in the args)
#
# 89967404311353 4253 nfsd 680 16 W 6 0 b5e9f4e5ab62a4fff5313a606b0ad4e3e6434714a2358bc5f55005d6c5502d80
test_write_digest_per_page_no_stalls() {
	rm -f mail
	truncate -s $((1000 * 512)) mail
	./btreplay/btreplay -l 32 -N -W mail
	s1=`cut -b $((680 * 512))-$((688 * 512)) mail`
	s2=`cut -b $((688 * 512))-$((696 * 512)) mail`
	if [ "b5e9f4e5ab62a4fff5313a606b0ad4e3" == "$s1" ] && \
		[ "e6434714a2358bc5f55005d6c5502d80" == "$s2" ]; then
		echo ok
	else
		echo "fail: $s2"
		exit 1
	fi
}

# Test 3: check that the write below was replayed correctly (from homes.replay.0):
# The homes traces have a digest per sector, or 256 bytes per 1 page (the -l 256 in the args)
#
# 778713324445453 166 pdflush 120 8 W 6 0 bf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8b1f0d2a95a877fc1796dc682d69c6ea13bf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8b
test_write_digest_per_sector() {
	rm -f homes
	truncate -s $((1000 * 512)) homes
	./btreplay/btreplay -x 1000 -l 256 -W homes
	s1=`cut -b $((120 * 512))-$((128 * 512)) homes`
	if [ "bf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8b1f0d2a95a877fc1796dc682d69c6ea13bf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8b" == "$s1" ]; then
		echo ok
	else
		echo "fail: $s1"
		exit 1
	fi
}

# Test 4: check that the write below was replayed correctly (from homes.replay.0):
# The homes traces have a digest per sector, or 256 bytes per 1 page (the -l 256 in the args)
#
# 778713324445453 166 pdflush 120 8 W 6 0 bf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8b1f0d2a95a877fc1796dc682d69c6ea13bf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8b
test_write_digest_per_sector_no_stalls() {
	rm -f homes
	truncate -s $((1000 * 512)) homes
	./btreplay/btreplay -x 1000 -l 256 -W homes
	s1=`cut -b $((120 * 512))-$((128 * 512)) homes`
	if [ "bf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8b1f0d2a95a877fc1796dc682d69c6ea13bf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8bbf619eac0cdf3f68d496ea9344137e8b" == "$s1" ]; then
		echo ok
	else
		echo "fail: $s1"
		exit 1
	fi
}

# Test 5: check that the write below was replayed correctly (from mail.replay.0) on a mapped device:
# The homes traces have a digest per 8 sectors, or 32 bytes per 1 page (the -l 32 in the args)
#
# 89967404311353 4253 nfsd 680 16 W 6 0 b5e9f4e5ab62a4fff5313a606b0ad4e3e6434714a2358bc5f55005d6c5502d80
test_write_digest_per_page_no_stalls_mapped() {
	sudo rm -f /opt/dev/mail
	sudo mkdir -p /opt/dev
	sudo truncate -s $((1000 * 512)) /opt/dev/mail
	echo mail /opt/dev/mail > map
	sudo ./btreplay/btreplay -M map -l 32 -N -W mail
	s1=`cut -b $((680 * 512))-$((688 * 512)) /opt/dev/mail`
	s2=`cut -b $((688 * 512))-$((696 * 512)) /opt/dev/mail`
	if [ "b5e9f4e5ab62a4fff5313a606b0ad4e3" == "$s1" ] && \
		[ "e6434714a2358bc5f55005d6c5502d80" == "$s2" ]; then
		echo ok
	else
		echo "fail: $s2"
		exit 1
	fi
}

test_write_digest_per_page
test_write_digest_per_page_no_stalls
test_write_digest_per_sector
test_write_digest_per_sector_no_stalls
test_write_digest_per_page_no_stalls_mapped

exit 0
